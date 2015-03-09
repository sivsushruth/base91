require "base91/version"

module Base91

	AVERAGE_ENCODING_RATIO = 1.2297
	ENCODING_TABLE = [
	    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
	    'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
	    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
	    'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
	    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '!', '#', '$', '%',
      '&', '(', ')', '*', '+', ',', '.', '/', ':', ';','<', '=',
      '>', '?', '@', '[', ']', '^', '_', '`', '{', '|', '}', '~',
	    '"'
	]
	DECODING_TABLE = [
	    91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	    91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	    91, 62, 90, 63, 64, 65, 66, 91, 67, 68, 69, 70, 71, 91, 72, 73,
	    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 74, 75, 76, 77, 78, 79,
	    80,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
	    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 81, 91, 82, 83, 84,
	    85, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
	    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 86, 87, 88, 89, 91,
	    91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	    91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	    91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	    91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	    91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	    91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	    91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91,
	    91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91, 91
	]

	def self.encode data
	    len = data.length
	    output = ''
	    ebq = 0
	    en = 0
	    ev = 0
	    j = 0
	    byte = 0
	    lenj = 0

	    if data.is_a? String
	        (0..len-1).each do |i|
	            byte = data[i].ord
	            if byte < 128
	                lenj = 1
	            elsif byte > 127 && byte < 2048
	                lenj = 2
	            else
	                lenj = 3
	            end
	            for j in 0..lenj-1
	                if lenj == 1
	                    ebq = ebq | byte << en
	                elsif lenj == 2
	                    if j == 0
	                        ebq = ebq | (((byte >> 6) | 192)) << en
	                    else
	                        ebq = ebq | ((byte & 63) | 128) << en
	                    end
	                else
	                    if j == 0
	                        ebq = ebq | (((byte >> 12) | 224) << en)
	                    elsif j == 1
	                        ebq = ebq | ((((byte >> 6) & 63) | 128) << en)
	                    else
	                        ebq = ebq | (((byte & 63) | 128) << en)
	                    end                
	                end
	            end
	            en+=8
	            if en > 13
	                ev = ebq & 8191
	                if ev > 88
	                    ebq = ebq >> 13
	                    en-=13
	                else
	                    ev = ebq & 16383
	                    ebq = ebq >> 14
	                    ebq-=14
	                end
	                output << "#{ENCODING_TABLE[ev%91]}#{ENCODING_TABLE[(ev/91) | 0]}"
	            end
	        end
	    else
	        (0..len-1).each do |i|
	            ebq = ebq | (data[i] & 255) << en
	            en += 8
	            if en > 13
	                ev = ebq & 8191
	                if ev > 88
	                    ebq = eqb >> 13
	                    en -= 13
	                else
	                    ev = ebq & 16383
	                    ebq = ebq >> 14
	                    en -= 14                    
	                end
	                output << "#{ENCODING_TABLE[ev%91]}#{ENCODING_TABLE[(ev/91) | 0]}"
	            end
	        end
	    end

	    if en > 0 
	        output+= ENCODING_TABLE[ebq % 91]
	        if en > 7 || ebq > 90
	            output << ENCODING_TABLE[(ebq / 91) | 0]
	        end
	    end
	    return output
	end

	def self.decode data
	    len = data.length
	    estimated_size = (len / AVERAGE_ENCODING_RATIO).to_i | 0
	    dbq = 0
	    dn = 0
	    dv = -1
	    i = 0
	    o = -1
	    byte = 0
	    output = Array.new(estimated_size) ##check here
	    if data.is_a? String
	        (0..len-1).each do |i|
	            byte = data[i].ord
	            if DECODING_TABLE[byte] != 91
	                if dv == -1
	                    dv = DECODING_TABLE[byte]
	                else
	                    dv+=(DECODING_TABLE[byte] * 91)
	                    dbq =  dbq | (dv << dn)
	                    if dv & 8191 > 88
	                        dn+=13
	                    else
	                        dn+=14
	                    end
	                    loop do 
	                        if ((o+=1) > estimated_size)
	                            output << (dbq & 0xFF)
	                        else
	                            output[o] = dbq & 0xFF
	                        end
	                        dbq = dbq >> 8
	                        dn-=8
	                        break if dn<=7
	                    end
	                    dv = -1
	                end
	            end 
	        end
	    else
	        (0..len-1).each do |i|
	            byte = data[i]
	            if DECODING_TABLE[byte] != 91
	                if dv == -1
	                    dv =DECODING_TABLE[byte]
	                else
	                    dv += (DECODING_TABLE[byte] * 91)
	                    dbq = dbq | dv << dn
	                    if (dv & 8191) > 88
	                        dn += 13
	                    else
	                        dn += 14
	                    end
	                    loop do 
	                        if ((o+=1) > estimated_size)
	                            output << (dbq & 0xFF)
	                        else
	                            output[o] = (dbq & 0xFF)
	                        end
	                        dbq = dbq >> 8
	                        dn-=8
	                        break if dn<=7
	                    end
	                    dv = -1
	                end
	            end
	        end
	    end
	    if dv != -1
	        if (o+=1) >= estimated_size
	            output << (dbq | dv << dn)
	        else
	            output[o] = (dbq | dv << dn)
	        end
	    end
	    if o > -1 && o < estimated_size -1
	        output = output[0..o+1]
	    end
	    return output.map(&:chr).join("")
	end
end