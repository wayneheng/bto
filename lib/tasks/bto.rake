require 'rubygems'
require 'mechanize'
require 'Rack'

namespace :bto do
  desc "TODO"
  task sync_projects: :environment do
    
    p = Project.all.first
    fetchFromHDB(p)
    syncUnits(p)
    
  end
  
  task check_launch: :environment do
    params = {}
    createProject(params)
  end

end

def fetchFromHDB(project)

  agent = Mechanize.new
  
  url = project.scrape_url
  
  puts "Fetching Url:" + url
  
  params = Rack::Utils.parse_query URI(url).query
  
  #Additional Parsing
  form_action_match = url.match(/\/(.*)\?/)
  form_action = form_action_match[1].split('/')[-1]
  params['action'] = form_action
  
  params['Neighbourhood'] = params['projName']
  contract_match = url.match(/;(.*)$/)
  params['Contract'] = contract_match[1]
  
  page = agent.get(url);
  
    def fillForm(page,block,params)
  
    form = page.form()
  
    form['Block'] = block
    form['Contract'] = params['Contract']
    form['Flat'] = params['Flat']
    form['Flat_Type'] = params['Flat_Type']
    form['Neighbourhood'] = 'N1'
    form['Town'] = params['Town']
    form['dteBallot'] = params['dteBallot']
    form['projName'] = 'N1 ;C50'
    
    form.action = params['action']
    
    form['DesType'] = 'A'
    form['EthnicA'] = 'Y'
    form['EthnicC'] = ''
    form['EthnicM'] = ''
    form['EthnicO'] = ''
    form['firstLoadMap'] = 'Yes'
    form['ViewOption'] = 'A'
    form['callPage'] = ''
    form['numSPR'] = ''
    form.method = 'POST'
  
    return form  
  
  end

  def saveResult(project_id,block,result)
    
    basePath = "ScrapedData"
    dateStr = Time.now.strftime('%m_%d_%Y_%H')
    
    filePath = "#{Rails.root.to_s}/#{basePath}/#{project_id}/#{dateStr}/#{block}"
    
    puts 'Saving to ' + filePath
    
    dirname = File.dirname(filePath)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
  
    File.open(filePath,'w') do |file|
      file.syswrite(result)
    end
    
  end
  

  project.block_list.each do |block|
    
    puts "Submitting Form for block:" + block
    
    form = fillForm(page,block,params)
    result = agent.submit(form)
    
    puts "Query Complete for block:" + block
    
    project_id = project.id
    saveResult(project_id,block,result.body)
    
    #TODO:randomise sleeping time
    sleep 1
    
  end
end

def fetchUnits(project,block)

    project_id = project.id
    
    unit_list = []

    basePath = "ScrapedData"
    dateStr = Time.now.strftime('%m_%d_%Y_%H')
    filePath = "#{Rails.root.to_s}/#{basePath}/#{project_id}/#{dateStr}/#{block}"
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
           
            price_match = unit_td.to_s.match(/\$(.*?)<\/td>/)
            
            unit_price =''
            if price_match
              unit_price = price_match[0].sub('</td>','').strip
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

  project.block_list.each do |block|
  
    puts "Parsing block:" + block
    unit_list = fetchUnits(project,block)
    
    unit_list.each{|x| hash[x['title']] = x}
    
  end
  
  # puts hash 
   
   has_changes = false
   project.units.each do |db_unit|
     
     remote_unit = hash[db_unit.title]
     
     if db_unit.is_taken != remote_unit['is_taken']
       
       puts "unit updated to taken:" + db_unit.title
       db_unit.is_taken = remote_unit['is_taken']
       db_unit.taken_date = Time.now
       db_unit.save()
       has_changes = true
     end
   end
   
   if has_changes
     project.version +=1
     project.save()
   end
  
end

def createUnits(project)
  
  project.block_list.each do |block|
  
    puts "Parsing block:" + block
    unit_list = fetchUnits(project,block)
    
    puts unit_list
    
    unit_list.each do |fetched_unit|
      
      unit = Unit.new()
      unit.title = fetched_unit['title']
      unit.price = fetched_unit['price']
      unit.blk = block
      #unit.blk = fetched_unit['unit_number']
      unit.is_taken = fetched_unit['is_taken']
      unit.project = project
      
      unit.save()
    end
    
  end
  
end


def createProject(params)
  
  project = Project.new()
  project.launch_id = 1
  project.title = "Telok Blangah ParcView"
  project.flat_type = 4
  project.version = 0
  project.index = 1
  project.blocks = ['90A','90B','91A','92B','93A','93B'].join(',')
  project.scrape_url = 'http://services2.hdb.gov.sg/webapp/BP13INTV/BP13EBSBULIST4?Town=Bukit%20Merah&Flat_Type=BTO&DesType=A&ethnic=Y&Flat=4-ROOM&ViewOption=A&dteBallot=201307&callPage=&projName=N1;C50'
  
  project.save()
  
  puts "Created Project:" + project.to_s
  
  fetchFromHDB(project)  
  createUnits(project)
 
end
