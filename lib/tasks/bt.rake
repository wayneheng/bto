require 'rubygems'
require 'mechanize'
require 'Rack'

#Run in the following order
#1 generate_json
#2 create_project
#3 setup_project

namespace :bt do
  desc "TODO"
  task :sync_projects => :environment do |task,args|
    
    projects = Project.all
    
    failed_projects = []
    
    projects.each do |p|
      
      puts "Syncing Project:" + p.id.to_s
      
      begin 
        syncProject(p)
      rescue Net::HTTP::Persistent::Error => ex
        puts "=====>TimeOut ERROR!:"
        puts ex.class
        puts "Project syncing timeout:" + p.id.to_s
        failed_projects.push(p)  
      end
      
      puts "Start sleeping"
      sleep(10)
      puts "End Sleeping"
      
    end
    
    #Second Attempt
    failed_projects.each do |p|
      
      puts "Second attempt to sync Project" + p.id.to_s
      
      begin 
        syncProject(p)
      rescue Net::HTTP::Persistent::Error => ex
        puts "=====>TimeOut ERROR!:"
        puts "2nd Attempt Project syncing timeout:" + p.id.to_s
      end
      
      puts "Start sleeping"
      sleep(2)
      puts "End Sleeping"
      
    end
    
  end

  task :sync_project, [:project_id] => :environment do |task, args|

    project_id = args.project_id

    puts "Sync Project:" + project_id.to_s

    project = Project.find(project_id)
    syncProject(project)
  end
  
  
  task :setup_project, [:project_id] => :environment do |task, args|

    project_id = args.project_id

    puts "Setup Project:" + project_id.to_s

    project = Project.find(project_id)
    setupProject(project)
  end

  task :clear_project, [:project_id] => :environment do |task, args|

    project_id = args.project_id

    puts "Clear Project:" + project_id.to_s

    project = Project.find(project_id)
    clearProject(project)
  end
  
  task :generate_json, [:project_id] => :environment do |task, args|

    project_id = args.project_id

    puts "Generating Json for Project:" + project_id.to_s

    project = Project.find(project_id)
    generateJson(project)
  end
  
  task :create_project, [:project_id] => :environment do |task, args|

    project_id = args.project_id

    puts "Creating Project from json:" + project_id.to_s

    createProjectFromJson(project_id)
    
  end 
  
def generateJson(project)
  
  result = project.to_json :include => 'blks'
  
  basePath = "Setup"
  filePath = "#{Rails.root.to_s}/#{basePath}/#{project.id}.json"
  puts 'Saving to ' + filePath

  File.open(filePath,'w') do |file|
    file.syswrite(result)
  end
  
end

def createProjectFromJson(project_id)
  
  #Load Json
  basePath = "Setup"
  filePath = "#{Rails.root.to_s}/#{basePath}/#{project_id}.json"
  puts 'Opening file: ' + filePath
  
  # File.open(filePath,'r') do |file|
    # result = file
  # end
  
  result = File.read(filePath)
  result = JSON.parse(result)
  
  puts "Result:" + result.inspect
  
  project = Project.find_or_create_by(id: result['id'])
  project.id = result['id']
  project.title = result['title']
  project.flat_type = result['flat_type']
  project.version = result['version']
  project.launch_id = result['launch_id']
  project.town_project_id = result['town_project_id']
  project.scrape_url = result['scrape_url']
  
  puts "Creating Project:" + project.inspect
  project.save()
 
  #Clear blks in db
  existingBlks = Blk.where("project_id = ?",project_id)
  existingBlks.each do |blk|
    puts "Deleting blk:" + blk.id.to_s
    blk.delete()
  end
  
  result['blks'].each do |blk|
    block = Blk.new()
    block.id = blk['id']
    block.title = blk['title']
    block.url = blk['url']
    block.contract = blk['contract']
    block.neighbourhood = blk['neighbourhood']
    block.project_id = blk['project_id']
    block.mapPath = blk['mapPath']
    block.save()
    puts "Creating block:" + block.inspect
  end
  
end
  
def fetchFromHDBForBlock(block)
  
  agent = Mechanize.new
  
  url = block.url
  
  url = url.gsub("%20"," ")
  
  puts "Fetching Url:" + url
  
  url = URI::encode(url)
  
  params = Rack::Utils.parse_query URI(url).query
  
  #Additional Parsing
  form_action_match = url.match(/\/(.*)\?/)
  form_action = form_action_match[1].split('/')[-1]
  params['action'] = form_action
  
  params['Neighbourhood'] = block.neighbourhood
  params['Contract'] = block.contract
  
  page = agent.get(url);
  
  def fillForm(page,block,params)
  
    form = page.form()
  
    form['Block'] = block.title
    form['Contract'] = params['Contract']
    form['Flat'] = params['Flat']
    form['Flat_Type'] = params['Flat_Type']
    form['Neighbourhood'] = params['Neighbourhood']
    form['Town'] = params['Town']
    form['dteBallot'] = params['dteBallot']
    form['callPage'] = params['callPage']
    #form['projName'] = params['projName']
    
    form.action = params['action']
    
    form['DesType'] = 'A'
    form['EthnicA'] = 'Y'
    form['EthnicC'] = ''
    form['EthnicM'] = ''
    form['EthnicO'] = ''
    form['firstLoadMap'] = ''
    form['ViewOption'] = 'A'
    form['numSPR'] = ''
    form.method = 'POST'
  
    pp form
  
    return form  
  
  end
  
  def saveResult(block,result)
    
    project_id = block.project.id
    block_title = block.title
    
    basePath = "ScrapedData"
    dateStr = Time.now.strftime('%m_%d_%Y_%H')
    
    filePath = "#{Rails.root.to_s}/#{basePath}/#{project_id}/#{dateStr}/#{block_title}"
    
    puts 'Saving to ' + filePath
    
    dirname = File.dirname(filePath)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
  
    File.open(filePath,'w') do |file|
      file.syswrite(result)
    end
    
  end
  
  puts "Submitting Form for block:" + block.title
  
  form = fillForm(page,block,params)
  result = agent.submit(form)
  
  puts "Query Complete for block:" + block.title
  
  saveResult(block,result.body)
      
end

def syncProject(project)
  
  project.blks.each do |blk|
    
    fetchFromHDBForBlock(blk)
    sleep(1)
  end
  
  puts "Completed Fetching from HDB for project:" + project.id.to_s
  
  syncUnits(project)
  
end


def fetchUnits(block)

    project_id = block.project_id
    
    unit_list = []

    basePath = "ScrapedData"
    dateStr = Time.now.strftime('%m_%d_%Y_%H')
    filePath = "#{Rails.root.to_s}/#{basePath}/#{project_id}/#{dateStr}/#{block.title}"
    puts 'Opening file: ' + filePath
  
    File.open(filePath,'r') do |file|
      
      doc = Nokogiri::HTML(open(file))

      tables = doc.css('td > table.tableGrid')      
      table = tables[-1] #Last table
      
      #puts table
      
      tableRows = table.css('> tr')
      
        tableRows.each do |tableRow|
        
        #puts tableRow
        
        tableRow.css('> td').each do |td|
          
          blkTable = td.css('table').first       
          blkTable.css('> tr').each do |unit_tr|
                        
            unit_td = unit_tr.css('td').first
            
            unit_font = unit_td.css('font')
            unit_title = unit_font.text
            unit_taken_class = unit_font.attr('class')
           
            if unit_taken_class.to_s == 'redtext'
              is_unit_taken = true
            else
              is_unit_taken = false
            end 
           
            price_match = unit_td.to_s.match(/\$(.*?)</)
            
            unit_price =''
            if price_match
              unit_price = price_match[0].sub('<','').strip
            end
            
           unit_number_match = unit_title.match(/-(.*)$/)
           unit_number = unit_number_match[1]
            
            unit = {}
            unit['title'] = unit_title.strip
            unit['is_taken'] = is_unit_taken
            unit['price'] =  unit_price.strip
            unit['unit_number'] = unit_number
            
            unit_list.push(unit)
          end
        end   
      end
    end
    
    return unit_list
end


def syncUnits(project)

  hash = {}

  project.blks.each do |blk|
  
    puts "Parsing block:" + blk.title
    unit_list = fetchUnits(blk)
    
    unit_list.each{|x| hash[x['title']] = x}
    
  end
  
  # puts hash 
   
   has_changes = false
   project.units.each do |db_unit|
     
     remote_unit = hash[db_unit.title]
     
     price = remote_unit['price']
     if price.length > 0 && price != db_unit.price
       db_unit.price = remote_unit['price']
       puts "updating price:" + price
       has_changes = true
     end
     
     if db_unit.is_taken != remote_unit['is_taken']
       
       puts "unit updated to taken:" + db_unit.title
       db_unit.is_taken = remote_unit['is_taken']
       db_unit.taken_date = Time.now
       has_changes = true
     end
     
     if has_changes
       db_unit.save()
     end
     
   end
   
   if has_changes
     project.version +=1
     project.save()
   end
  
end

def clearProject(project)
  
  project.units.delete_all
  project.save()
  
  puts" Cleared Project:" + project.id.to_s
  
end

#Creation
def setupProject(project)
  
  if project.units.length > 0
    puts "Project already has units. Need to clear before resetup"
    return
  end

  project.blks.each do |blk|
    
    fetchFromHDBForBlock(blk)
    
  end
  
  puts "Completed Fetching from HDB for project:" + project.id.to_s
  
  createUnits(project)
 
end

def createUnits(project)
  
  puts "Blk Count:" + project.blks.length.to_s
  
  project.blks.each do |blk|
  
    puts "Parsing block:" + blk.title
    unit_list = fetchUnits(blk)
    
    puts unit_list
    
    unit_list.each do |fetched_unit|
      
      unit = Unit.new()
      unit.title = fetched_unit['title']
      unit.price = fetched_unit['price']
      unit.blk = blk.title
      #unit.blk = fetched_unit['unit_number']
      unit.is_taken = fetched_unit['is_taken']
      unit.project = project
      
      unit.save()
    end
    
  end
  
end

end

