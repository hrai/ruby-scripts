=begin

This script is used for converting people types into xslt related code to be 
used in People.xsl file.

The file stores text in the format below: 
--People Type---HIDE---
Current Owner	YES
1 - Applicant	NO
2 - Builder	NO
-----------------------
It will strip out the numbers and hyphens.
It will only display the people with 'NO' flag.
It will wrap the person in "contains(description, 'PersonType')" string.
It will join the above list of strings using separator and prints the result.

=end
def clean_string(fileToReadFrom, separator)

	#read from file
	file = File.open(fileToReadFrom, 'r')
	arr = Array.new
	
	$result = ""

	while(line = file.gets)
		text = line.chomp.strip.sub(/\d*/, '').sub(/-/, '')

		if (!text.empty? && (text.include? "NO"))
			text = text.sub "NO", ''
			arr.push text.strip
		elsif
			puts "Hidden is set to true for \"#{text}\""
		end
	end

	file.close
	
	wrapper_str =  "contains(description, '')"
	arr = arr.map do |item| 
		 "contains(description, \'#{item}\')"
		end
	
	puts
	puts "---- People to display ------"
	puts arr.join separator
end


clean_string("people.txt", " or ")

#puts $result
