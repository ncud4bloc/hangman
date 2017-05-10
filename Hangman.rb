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
    puts "Welcome! Is this a new game or"
    puts "are you continuing an old one?"
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
    @out_gallows = @gallows
    @out_underline = @underline
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
    @in_letters = @saved_output.gets
    @letters = @in_letters.split("")
    @letters.delete("\n")
    @in_num_letters = @saved_output.gets
    @num_letters = @in_num_letters.to_i
    @in_guesses = @saved_output.gets
    @guesses = @in_guesses.split("")
    @guesses.delete("\n")
    @in_wrong_guesses = @saved_output.gets
    @wrong_guesses = @in_wrong_guesses.split("")
    @wrong_guesses.delete("\n")
    @in_fail = @saved_output.gets
    @fail = @in_fail.to_i
    @in_gallows = @saved_output.gets
    @in_gallows.gsub!("[", " ")
    @in_gallows.gsub!("]", "")
    @in_gallows.gsub!("|\\\\", "|\\")
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
      continue
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
          puts "Uhh, enter just ONE letter, mmmmm...O-kay?"
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
      plot
      puts " "
      puts "************************"
      puts "*                      *"
      puts "*  We have a winner!!  *"
      puts "*                      *"
      puts "************************"
      puts " "
      @finish = true
    elsif @fail == 0
      plot
      puts " "
      puts "************************"
      puts "*                      *"
      puts "*  Dead man hanging!!  *"
      puts "*                      *"
      puts "************************"
      puts " "
      @finish = true
    else
    end
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def continue
    unless (@fail == 0) || (@guesses == @letters)
      puts " "
      puts "Continue game or save & quit? (enter C or Q)"
      answer = false
      while answer == false
        cont = gets.chomp.upcase.to_s
        if (cont != "C" && cont != "Q")
          puts "Enter a \"C\" or an \"Q\" please!"
          answer = false
        elsif cont == "Q"
          game_save
          puts "Saving game before exiting...done"
          answer = true
          @finish = true
        elsif cont == "C"
          answer = true
        else 
        end
      end
    end
  end

# >< <> >< <> >< <> >< >< <> >< <> >< <> >< >< <> >< <>

  def goodbye
    puts " "
    if (@fail != 0) && (@guesses != @letters)
      puts "GAME OVER...saved in \"hangman_save#{@time.day}#{@time.hour}#{@time.min}#{@time.sec}.txt\""
    elsif @fail == 0
      puts "***   GAME OVER...the word was \"#{@letters.join("")}\"   ***"
    else
      puts "***   GAME OVER   ***"
    end
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