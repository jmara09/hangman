# frozen_string_literal: true

require_relative 'lib/hangman'

require 'yaml'

words = File.open('google-10000-english-no-swears.txt').map(&:chomp)

hangman = Hangman.new(words)

hangman.start
