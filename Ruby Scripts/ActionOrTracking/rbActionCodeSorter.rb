require 'stringio'
@str_buffer = StringIO.new	#class variable


def read_file_into_array (file)
	result = Array.new
	file = File.open(file, 'r')
	while(str = file.gets)
		str = str.chomp
		
		if(str.length != 0)
			if str.include? '-'
				arr = str.split '-'
			else 
				arr = str.split /\s+NO\s+/
			end
			
			if !arr[0].empty?
				result.push (arr[0].strip)
			end
		end
	end
	
	return result
end		

def sort_action_codes 
	str_arr = read_file_into_array "txtActioncode.txt"

	#sort str_arr in alphabetical order
	str_arr = str_arr.sort

	#sort str_arr by length of the element
	str_arr = str_arr.sort_by {|str| str.length }	

	return str_arr
end

def print_test_condition_for_xslt(codes, counter)
	variable_name = ARGV[0]	
 	result = "(string-length($#{variable_name}) = #{counter} and contains('#{codes}', $#{variable_name}))"
 	puts result
 	
 	@str_buffer << (result + " or ")
end


def sort_print_acodes (sorted_ac, code_separator)
	acodes = Array.new

	counter = 0

	sorted_ac.each do |ac|
		#fix for first element 
		counter = ac.length if counter == 0
		
		 if counter != ac.length
			puts "----------Item length(" + (counter).to_s + ")----------------"
			codes = acodes.join(",")
			puts codes
			
			print_test_condition_for_xslt(codes, counter)
			
			counter = ac.length
			acodes.clear

			puts 
			#print "Item length(" + counter.to_s + "): "
		#elsif
		end
			acodes.push ac
	end
	
	if !acodes.empty?
			puts "----------Item length(" + (counter).to_s + ")----------------"
			codes = acodes.join(",")
			puts codes
			
			print_test_condition_for_xslt(codes, counter)
			
	end 
	
		
	puts
end


sorted_ac = sort_action_codes

separator = ","
sort_print_acodes(sorted_ac, separator)
	
puts "------------condition------------------"
str_buff_val = @str_buffer.string
str_buff_val = str_buff_val.strip
puts str_buff_val[/(.*)\s/, 1]




