
$newLine = "\r\n"
$app_types = ""


def is_i? (string_to_check)
	return (string_to_check.is_a? String) && /\A\d+\z/.match(string_to_check)
end


def getRelatedAppsAttributes(str)
	attributes = 'DisplayableRelatedAppTypes="" DisplayRelatedParentApp="yes" DisplayRelatedAppsByAppPart="" '

	#puts (str||="").include? "parts"

	if str.nil? 
		return attributes
	elsif str.include? "parts"
		attributes.gsub! 'DisplayRelatedAppsByAppPart=""', 'DisplayRelatedAppsByAppPart="yes"' 
	else str.include? "parts"
		attributes.gsub! 'DisplayRelatedAppsByAppPart=""', 'DisplayRelatedAppsByAppPart="no"' 
	end
	
	relatedAppTypes = ""

	#split the string with comma
	a =str.split(",").each do |item|
		if is_i? item.strip.chomp
			relatedAppTypes << item.strip.chomp + ","
		end
	end 
	
	#replace the appTypes attribute
	attributes.gsub! 'DisplayableRelatedAppTypes=""', 'DisplayableRelatedAppTypes="' + relatedAppTypes[0..(relatedAppTypes.length-2)] + '"'

	return attributes
end


def getDocTypeXmlNode(line, receivedCutoffDate)

	if line.include? "NO"	
		#replace 'NO' with '-'
		line.gsub!('NO', '-')
	else	
		#replace 'YES' with '-'
		line.gsub!('YES', '-')
	end

	#split string with '-'
	arr = line.split('-')

	#parse 3rd element in the array for related apps configuration
	relatedAppsAttr = getRelatedAppsAttributes(arr[2])

	if relatedAppsAttr.nil?
		relatedAppsAttr = ''
	end
	
	#p arr
	$app_types << arr[0].strip.chomp + ','

	if receivedCutoffDate.nil?
		date = '01/10/2015'
		puts "receivedCutoffDate argument not supplied. Setting the value of the date as #{date}"
		receivedCutoffDate = date 
	end

	return '<Type TKey="' +  arr[0].strip.chomp + '" Description="' + arr[1].strip.chomp +  '" ATDISDesc="" ReceivedDateCutOff="' + receivedCutoffDate + '" ' + relatedAppsAttr + ' />' + $newLine
end

def getTypeNodes(fileToReadFrom, receivedCutoffDate)

	#read from file
	file = File.open(fileToReadFrom, 'r')
	$result = ""

	while(line = file.gets)
		text = line.strip.chomp
		text ||= ""

		if(text.length > 0)
			$result << getDocTypeXmlNode(line, receivedCutoffDate)
		end
	end

	file.close
end


def writeXmlToFile(file)

	#write xml to file
	file = File.open(file, 'w')

	xmlHeader = '<?xml version="1.0" standalone="yes"?>' + $newLine
	xmlContent = '<ApplicationTypes>' + $newLine + $result
	xmlContent << '<Type TKey="' + $app_types[0...($app_types.length - 1)] + '" Description="All Applications" DisplayOnly="True" />'
	xmlContent << $newLine + '</ApplicationTypes>'
	file.write(xmlHeader + xmlContent)
	file.close

end


typeNodes = getTypeNodes('txtDocType&Desc.txt', ARGV[0])
writeXmlToFile('xmlDoctype.xml')

#puts $result
