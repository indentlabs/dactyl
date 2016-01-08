module ParserHelper
	
	def parse_document input_file
		if input_file.content_type == "text/plain" then
			document = input_file.read
			flash[:notice] = 'File processed'
		elsif input_file.content_type.include? "pdf"
			document = parse_PDF input_file
			flash[:notice] = "PDF Processed."
		elsif input_file.content_type.include? "rtf"
			flash[:notice] = "Rich Text Format detected but not implemented."
		elsif input_file.content_type.include? "officedocument"
			flash[:notice] = "Word Document detected but not implemented."
		else
			flash[:notice] = input_file.content_type + " not processed."
			document = ""
		end

		# Protect against Cross Site Scripting (XSS) and other injection attacks by sanitizing text
		full_sanitizer = Rails::Html::FullSanitizer.new
		full_sanitizer.sanitize(document)

		return document

	end

	private
		def parse_PDF input_file
			reader = PDF::Reader.new(input_file.tempfile)
			document = ""
			reader.pages.each do |page|
  			document += page.text
			end
			return document
		end

end