module ParserHelper
	
	def parse_document input_file

		# Select parser based on mime/type
		if input_file.content_type == "text/plain" then
			document = input_file.read
			flash[:notice] = 'Plain text file processed'
		elsif input_file.content_type.include? "pdf"
			document = parse_PDF input_file
		elsif input_file.content_type.include? "rtf"
			document = parse_RTF input_file
		elsif input_file.content_type.include? "officedocument"
			document = parse_DOCX input_file
		else
			flash[:notice] = input_file.content_type + " not supported."
			document = ""
		end

		# Protect against Cross Site Scripting (XSS) and other injection attacks by sanitizing document
		full_sanitizer = Rails::Html::FullSanitizer.new
		full_sanitizer.sanitize(document)

		return document

	end

	private
		# Use 'pdf-reader' gem to parse PDF
		def parse_PDF input_file

			begin
				reader = PDF::Reader.new(input_file.tempfile)
			# Catch common PDF parser error
			rescue PDF::Reader::MalformedPDFError => error
				flash[:alert] = "Error parsing document.  Is this a Portable Document Format (PDF) file?"
				return ""
			end
			document = ""
			reader.pages.each do |page|
  			document += page.text
			end

			flash[:notice] = "PDF Processed."
			return document

		end

		# Use 'ruby-rtf' gem to parse RTF
		def parse_RTF input_file

			begin
				reader = RubyRTF::Parser.new.parse(input_file.read)
			# Catch most common error for invalid RTF
			rescue RubyRTF::InvalidDocument => error
				flash[:alert] = "Error parsing document. Is this a Rich Text Format file (rtf)?"
				return ""
			end

			document = ""
			reader.sections.each do |section|
				document << section[:text].force_encoding('UTF-8')
			end

			flash[:notice] = "RTF Processed."
			return document

		end

		# This is addmittely klunky.  Definitely a kludge.
		# Use 'docx-html' gem to convert docx to html and then use Nokogiri to extract text
		def parse_DOCX input_file

			begin
				reader = Docx::Document.open(input_file.tempfile)
			# Catch common error to invalid DOCX
			rescue Zip::ZipError => error
				flash[:alert] = "Error parsing document. Is this a Word Docuemnt (docx)?"
				return ""
			end
			document = Nokogiri::HTML(reader.to_html).text
			
			flash[:notice] = "Word Document (docx) Processed."
			return document
			
		end

end