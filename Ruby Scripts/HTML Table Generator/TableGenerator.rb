def generate_table(file_name)
	file = File.open(file_name, 'r')
	$result = ''
	
	while(text = file.gets)
		puts text
		
		arr = text.split /\t/
		$result << '<tr>' + (arr.collect { |ele| '<td>' + ele + '</td>'}).join + "</tr>\n"
	end

	file.close
	
	$result = '<table>' + $result + '</table>'
	puts $result
	
	parsed_file = 'parsed-content.txt'

	if !File.exists? parsed_file
		f = File.new(parsed_file,'w')
	else
		f = File.open(parsed_file, 'w')
	end

	f.write($result)
end

generate_table('table-content.txt')
