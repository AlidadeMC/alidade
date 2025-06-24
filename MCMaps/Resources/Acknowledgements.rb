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

markdown_file = File.open("Credits.md").readlines.map { |line| line.chomp }
trimmed = markdown_file.map do |line|
    plaintext(line)
end

credit_text = trimmed.join("\\n")
credits_file = "\"Credits\" = \"Credits\";\n\"credit_text\"=\""
credits_file << credit_text
credits_file << "\";\n"

File.open("Settings.bundle/en.lproj/Credits.strings", 'w') { |file|
    file.write(credits_file)
}