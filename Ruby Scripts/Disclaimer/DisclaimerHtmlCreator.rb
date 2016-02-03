=begin

This script is used for converting people types into xslt related code to be 
used in People.xsl file.

The file stores free text.

It reads a file, parses the content and writes to another file..

=end
def get_disclaimer_string(fileToReadFrom)

	#read from file
	file = File.open(fileToReadFrom, 'r')
	arr = Array.new
	arr_list = Array.new
	heading_tag = 'h4'
	
	is_empty = lambda { |text| text.strip.chomp.empty? }
	
	while(text = file.gets)
		if !is_empty.call text
			if !text.match(/^\t/)
				#get the array items and create an html list
				if !arr_list.empty?
					arr.push "<ul>" + arr_list.join + "\n" + "</ul>"
					arr_list.clear
				end
				
				#add heading tag
				if text.start_with? heading_tag
					arr.push "<#{heading_tag}>" + (text.sub! "#{heading_tag}",'') + "</#{heading_tag}>"
				else
					arr.push '<p class="section">' + text + '</p>'
				end
				
			else
				arr_list.push "<li>" + text + "</li>\n"
			end
		elsif
			arr.push "<br/>"
		end
	end
	
	if !arr_list.empty?
		arr.push "<ul>" + arr_list.join + "\n" + "</ul>"
	end
		
	file.close
	
	return arr.join "\n"
end

def write(file_loc, str)
	file = File.open(file_loc, "w")
	
	file.write str
	file.close
	
	puts "Content parsed and written to the file."
end


disc_str = get_disclaimer_string("disclaimer.txt")
write("parsed_content.txt", disc_str)

#puts $result
