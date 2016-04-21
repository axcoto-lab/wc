require 'pp'

class Analyzer
  FILENAME = "alice-in-wonderland.txt"
  REGEX = /[\s\t,\(\)\-\_\.\;\:']+/

  def self.top_ten_words(filename)
    words = Hash.new(0)
    File.open(filename).each do |line|
      if tokens = line.split(REGEX)
        tokens.each do |w|
          next if w == ""
          words[w] += 1
        end
      end
    end

    words = words.sort_by { |k, v| v }.reverse
    words[0..9]
  end

  def self.two_words_count(filename)
    words = Hash.new(0)

    File.open(filename).each do |line|
      if tokens = line.split(REGEX)
        count = 0
        tokens = tokens.select { |t| t.strip != "" }
        while count < tokens.length
          words["#{tokens[count]} #{tokens[count + 1]}"] += 1
          count += 1
        end
      end
    end
    words = words.sort_by { |k, v| v }.reverse
  end

  def self.setence_start_with(prefix, word_count = 10)
    if prefix.count(' ') == 0
      stop_word = prefix
    else
      stop_word = prefix.split(' ').last
    end
    @word_pairs ||= two_words_count(FILENAME)

    candidate_lists = @word_pairs.select { |wp| wp[0].start_with? stop_word }.map { |m| m[0] }

    next_pair = ""
    attempt = 0
    loop do
      next_pair = candidate_lists.sample

      # This strategy doesn't work out, step back
      # We cannot find enough word pair start with end words of previous sentence
      if (attempt >= candidate_lists.length) || (candidate_lists.length <= 1)
        words = prefix.split(" ")
        words.pop #step back
        sentence = words.join(" ")
        return setence_start_with(sentence, word_count)
      end
      attempt += 1

      break if word_start_with?(next_pair.split(" ").last)
    end

    words = prefix.split(" ")
    words.pop
    sentence = (words << next_pair).join(" ").gsub(/s\+/," ")
    if sentence.count(' ') == word_count - 1
      sentence
    else
      setence_start_with(sentence, word_count)
    end
  end

  def self.word_start_with?(word)
    @word_pairs ||= two_words_count(FILENAME)
    found = false
    @word_pairs.each do |pair|
      if pair[0].start_with?(word + " ")
        found = true
        break
      end
    end
    found
  end
end

puts "Top ten words"
pp Analyzer.top_ten_words("alice-in-wonderland.txt")
puts "\n\n"

puts "Top ten pair of word count"
pp Analyzer.two_words_count("alice-in-wonderland.txt")[0..10]
puts "\n\n"

puts "Random sentency with 10 words with said"
pp Analyzer.setence_start_with("said", 10)
puts "\n\n"

puts "Random sentency with 10 words start with the"
pp Analyzer.setence_start_with("the", 10)
puts "\n\n"
