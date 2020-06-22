using Pkg; Pkg.activate("/home/user/src/Hangman")

using Hangman

import Hangman: trans, newgame, scanleft, CharGuess, MealyStep, Output, Input, MsgEmpty, NewGame, MsgEmpty, MsgGotIt, MsgWrong, MsgRight, MsgNewGame, MsgGameOverWon, MsgGameOverLost

using Gtk

"Catches failures and print backtrace, the \"normal\" behavior that is sometimes supressed in Julia"
macro printbt(f)
    f.args[2] = quote
        try
            $(f.args[2])
        catch ex
            stack = catch_backtrace()
            local buffer = IOBuffer()
            showerror(buffer, ex)
            write(buffer, "\n\n")
            for bt in stacktrace(stack)
                showerror(buffer, bt)
                write(buffer, '\n')
            end
            seekstart(buffer)
            println(read(buffer, String))
        end
    end
    f
end






app = GtkBuilder(filename="hangman.glade")
win = app["window1"]

state = Hangman.NoGame()


@printbt function trigger(inp)
    global state

    st = trans(state, inp)
    @show state = st.state
    # @info st.output
    @info handle_output(st.output)
end


@printbt function handle_output(msg::MsgEmpty)
    GAccessor.text(app["messages"], "Invalid input, type a single character please.")
end

@printbt function handle_output(msg::MsgRight)
    GAccessor.text(app["status"], "$(state.guess) - $(state.lives) lives left")
    GAccessor.text(app["messages"], "You guessed right!")
end

@printbt function handle_output(msg::MsgWrong)
    GAccessor.text(app["status"], "$(state.guess) - $(state.lives) lives left")
    GAccessor.text(app["messages"], "Incorrect.")
end

@printbt function handle_output(msg::MsgGotIt)
    GAccessor.text(app["messages"], "Already got this letter.")
end

@printbt function handle_output(msg::MsgNewGame)
    GAccessor.text(app["status"], "$(state.guess) - $(state.lives) lives left")
    GAccessor.text(app["messages"], "A new game has started...")
end

@printbt function handle_output(msg::MsgGameOverWon)
    GAccessor.text(app["status"], "$(state.laststate.guess) - $(state.laststate.lives) lives left")
    GAccessor.text(app["messages"], "You won!!")
end

@printbt function handle_output(msg::MsgGameOverLost)
    GAccessor.text(app["status"], "$(state.laststate.guess) - $(state.laststate.lives) lives left")
    GAccessor.text(app["messages"], "GAME OVER - you lost...")
end


@printbt function newgame(_)
    word = Gtk.get_gtk_property(app["word"], :text, String)
    @info word

    trigger(NewGame(word))
end


@printbt function newguess(_)
    guess = Gtk.get_gtk_property(app["guess"], :text, String)
    @info guess

    trigger(CharGuess(guess))
end


signal_connect(newgame, app["newgame"], "clicked")

signal_connect(newguess, app["newguess"], "clicked")

showall(win)
