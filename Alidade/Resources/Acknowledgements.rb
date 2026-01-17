def plaintext(line)
    header = line.match(/^\*\*([a-zA-Z\s]+)\*\*\s*$/)
    link = line.match(/^- \[\*\*(.*)\*\*\]\((.*)\) - (.*)$/)
    if header != nil
        return header.captures[0].upcase
    elsif link != nil
        libname = link.captures[0]
        liblink = link.captures[1]
        license = link.captures[2]
        return "- #{libname}: #{license} (#{liblink})"
    else
        return line
    end
end

input_file, output_file, _ = ARGV
if input_file.nil?
    puts "error: Input file is missing or misconfigured."
    exit 1
end

if output_file.nil?
    puts "error: Output file is missing or misconfigured."
    exit 1
end

puts "note: Source is #{input_file}"
puts "note: Target is #{output_file}"

markdown_file = File.open(input_file).readlines.map { |line| line.chomp }
trimmed = markdown_file.map do |line|
    plaintext(line)
end

if trimmed.empty?
    puts "error: The credits file is empty."
    exit 2
end

credit_text = trimmed.join("\\n")
credits_file = "\"Credits\" = \"Credits\";\n\"credit_text\"=\""
credits_file << credit_text
credits_file << "\";\n"

File.open(output_file, 'w') { |file|
    file.write(credits_file)
}
puts "note: Credits have been rebuilt."
