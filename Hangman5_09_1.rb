module HangmanMethods

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def greeting
    puts " "
    puts "               ----------------------------"
    puts "              |       H A N G M A N        |"
    puts "               ----------------------------"
    puts " "
    puts "***********************************************************"
    puts "*                                                         *"
    puts "*  Welcome to Hangman, where you guess wrong seven times  *"
    puts "*                                                         *"
    puts "*                      YOU HANG!!                         *"
    puts "*                                                         *"
    puts "***********************************************************"
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def start_game

    @finish = false

    puts " "
    puts "Welcome, foul miscreant! Is this a new game or are you"
    puts "continuing an old one?"
    puts " "
    puts "Enter \"1\" to start a new game"
    puts "Enter \"2\" to continue a saved game"
    puts " "

    response = false
    while response == false
      answer = gets.chomp.to_s
      if answer != "1" && answer != "2"
        puts "No! Enter a 1 or a 2....how bloody hard is that?!"
      else 
        response = true
        if answer == "1"
          puts "Start a new game:"
          new_game
        else
          puts "Continue a saved game:"
          continue_game
        end
      end
    end
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def new_game

    @guesses = []
    @wrong_guesses = []
    @fail = 7

    words = File.readlines("dictionary.txt")
    words.each do |w|
      w.gsub!("\\","")
    end

    words_sized = []
    words.each do |l|
      if l.length > 4 && l.length <13
        words_sized.push(l)
      else next
      end
    end

    word = words_sized[rand(words_sized.length)].upcase
    @letters = word.split("")[0..-2]
    #puts "#{@letters}"         # to be removed when game completed

    @num_letters = @letters.length
    @underline = "-- "

    for num in (0..@num_letters - 1)
      @guesses[num] = " "
    end

    game_save

  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def game_save

    @letters_map = @letters.map {|x| x.to_s}
    @out_letters = @letters_map.join

    @out_num_letters = @num_letters.to_s

    @guesses_map = @guesses.map {|x| x.to_s}
    @out_guesses = @guesses_map.join

    @wrong_guesses_map = @wrong_guesses.map {|x| x.to_s}
    @out_wrong_guesses = @wrong_guesses_map.join

    @out_fail = @fail.to_s

#    @gallows_map = @gallows.map {|x| x.to_s}
#    @out_gallows = @gallows_map.join
    @out_gallows = @gallows

    @out_underline = @underline

    puts "My Output Format: \n"
    puts "#{@out_letters}"
    puts "#{@out_num_letters}"
    puts "#{@out_guesses}"
    puts "#{@out_wrong_guesses}"
    puts "#{@out_fail}"
    puts "#{@out_gallows}"
    puts "#{@out_underline}"

    @time = Time.new
    @my_save = File.open("hangman_save#{@time.day}#{@time.hour}#{@time.min}#{@time.sec}.txt", "w") do |f|
      f.puts "#{@out_letters}"
      f.puts "#{@out_num_letters}"
      f.puts "#{@out_guesses}"
      f.puts "#{@out_wrong_guesses}"
      f.puts "#{@out_fail}"
      f.puts "#{@out_gallows}"
      f.puts "#{@out_underline}"
    end

  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def continue_game

    puts "Enter saved game you wish to continue:"
    @renew = gets.chomp
    @saved_output = File.open(@renew)
    #@saved_output = File.open("hangman_save9112820.txt")

    @in_letters = @saved_output.gets
    @letters = @in_letters.split("")
    @letters.delete("\n")
    #puts "#{@letters}"

    @in_num_letters = @saved_output.gets
    @num_letters = @in_num_letters.to_i
    #puts @num_letters.is_a? Integer

    @in_guesses = @saved_output.gets
    @guesses = @in_guesses.split("")
    @guesses.delete("\n")
    #puts "#{@guesses}"

    @in_wrong_guesses = @saved_output.gets
    @wrong_guesses = @in_wrong_guesses.split("")
    @wrong_guesses.delete("\n")
    #puts "#{@wrong_guesses}"

    @in_fail = @saved_output.gets
    @fail = @in_fail.to_i
    #puts @fail.is_a? Integer

    @in_gallows = @saved_output.gets
    @in_gallows.gsub!("[", " ")
    @in_gallows.gsub!("]", "")
    @gallows = @in_gallows.split(",")
    @gallows.each do |w|
      w.gsub!("\" ","")
    end
    @gallows.each do |w|
      w.gsub!("\"","")
    end
    @gallows.each do |w|
      w.gsub!("\n","")
    end
    #puts @gallows
    #puts "#{@gallows}"

  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def game_setup

    @level0 = "    ____    "
    @level1 = "   |    |   "
    @level2 = "   |        "
    @level3 = "   |        "
    @level4 = "   |        "
    @level5 = "   |        "
    @level6 = "   |        "
    @level7 = "  -^------  "

    @wrong2 = "   |    O   "
    @wrong31 = "   |   /    "
    @wrong32 = "   |   /|   "
    @wrong33 = "   |   /|\\  "
    @wrong4 = "   |    |   "
    @wrong51 = "   |   /    "
    @wrong52 = "   |   / \\  "

    @gallows = [@level0, @level1, @level2, @level3, @level4, @level5, @level6, @level7]

  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def plot

    #greeting
    puts @gallows
    puts " "

    for tmplength in 0..@guesses.length
      print "#{@guesses[tmplength]}  "
    end

    puts " "
    @num_letters.times {print @underline}
    puts " "
    puts " "
    print "Wrong guesses: "
    print "#{@wrong_guesses.join(", ")}"
    puts " "
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def turns

    while @finish == false
      plot
      take_a_guess
      game_over
      quit
    end

    if @finish == true
      goodbye
    else
    end

  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def take_a_guess

    puts " "
    puts "Enter your letter guess:"
    valid_answer = false
    while valid_answer == false
      @howbout = gets.chomp.upcase.to_s
        if @howbout == (0..9)
          puts "No, not a number...enter a letter, a letter, stupid!"
        elsif @howbout.length > 1
          puts "Uhh, enter just ONE letter, ya moron!"
        else 
          valid_answer = true
        end
    end

    @hitcount = 0
    for index in 0...@num_letters
      if @letters[index] == @howbout
        @guesses[index] = @howbout
        @hitcount += 1
      else
      end
    end
      if @hitcount != 0
        puts "\n\n\n"
        puts "Yes, #{@hitcount} matches for #{@howbout}!"
      else
        puts "\n\n\n"
        puts "No, #{@howbout} is not a match"
        @wrong_guesses.push(@howbout)
        @fail -= 1
        case @fail
          when 6
            @gallows[2] = @wrong2
          when 5
            @gallows[3] = @wrong31
          when 4
            @gallows[3] = @wrong32
          when 3
            @gallows[3] = @wrong33
          when 2
            @gallows[4] = @wrong4
          when 1
            @gallows[5] = @wrong51
          when 0
            @gallows[5] = @wrong52
        end
      end
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def game_over

    if @guesses == @letters
      puts " "
      puts "Game Over....We have a winner!!"
      puts " "
      plot
      @finish = true
    elsif @fail == 0
      puts " "
      puts "Game Over....Dead man hanging!"
      puts " "
      plot
      @finish = true
    else
    end

  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def quit
    puts " "
    puts "Continue game or save & quit? (enter C or S)"
    answer = false
    while answer == false
      cont = gets.chomp.upcase.to_s
      if (cont != "C" && cont != "S")
        puts "Enter a \"C\" or an \"S\" please!"
        answer = false
      elsif cont == "S"
        game_save
        puts "Saving game before exiting...done"
        answer = true
        @finish = true
      else
        answer = true
      end
    end
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def goodbye
    puts " "
    puts "GAME OVER...the word was \"#{@letters.join("")}\""
    puts " "
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

end

#************************************************************************
#
# Classes defined below
#
#************************************************************************

#************************************************************************

class Game
  include HangmanMethods

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>
  
  def initialize
    greeting
    game_setup
    start_game
#    game_setup
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def play
    turns
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

end

#************************************************************************

hang = Game.new
hang.play