class MetricsJob < ApplicationJob
  def load_book_and_corpus_from_book_id(book_id)
    require 'net/http'
    require 'uri'

    book = Book.find_by(id: book_id)
    ar_corpus = book.hosted_corpus.first

    puts "Downloading book from #{ar_corpus.url}..."
    corpus_text = Net::HTTP.get(URI.parse(ar_corpus.url))

    puts "Preparing corpus for analysis..."
    corpus = Corpus.new(text: corpus_text)

    return [book, corpus]
  end

  def compute(corpus, metric_group, computations_to_do)
    computations_to_do.each do |service, method, format_style|
      puts "Computing #{service}::#{method}..."

      start  = Time.now
      result = service.send(method, corpus)
      finish = Time.now

      puts "Done in #{(finish - start).round(5)} seconds. Saving result."
      metric = metric_group.metrics.find_or_create_by(name: method)
      metric.update!(value: result, format_style: format_style)
    end
  end

end
