require 'pp'

class Analyzer
  FILENAME = "alice-in-wonderland.txt"

  class << self
    def longest
      word = ""
      File.open(FILENAME).each do |line|
        if tokens = line.strip.split(/[\s\t-_]+/)
          tokens.each do |w|
            word = w if word.length < w.length
          end
        end
      end
      puts "Longest word is: #{word}"

    end

    def count_word
      wc = {}
      File.open(FILENAME).each do |line|
        if tokens = line.strip.split(/[\s\t]+/)
          tokens.each do |w|
            w.downcase!
            next if ['', ' ', "\t"].include?(w)
            wc[w] = 0 if wc[w].nil?
            wc[w] += 1
          end
        end
      end
      wc = wc.sort_by { |k,v| v }.reverse
      5.times do |i|
        w =  wc.shift
        puts "#{i} prize: #{w[0]} #{w[1]}"
      end
    end

    def count_char
      wc = {}
      File.open(FILENAME).each do |line|
        if tokens = line.strip.split('')
          tokens.each do |c|
            c.downcase!
            next if ['', ' ', "\t"].include?(c)
            wc[c] = 0 if wc[c].nil?
            wc[c] += 1
          end
        end
      end
      report wc
    end

    private

    def report(occurence)
      tokens = occurence.sort_by { |k,v| v }.reverse
      pp tokens
    end
  end
end

Analyzer.count_char
Analyzer.count_word
Analyzer.longest
