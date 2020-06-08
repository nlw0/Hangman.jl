using Hangman

import Hangman: trans, newgame, scanleft, MyChar, MealyStep, Output, Input

using Test


@testset "All tests" begin


# proc(s,c) = trans(s,c).state

# foldl(proc, MyChar.(['e', 't', 'x', 'q', 's']), init=newgame("teste"))

gt1 = [
    MealyStep{Nothing}(nothing, Hangman.NeedInput("teste", "_____", 9)),
    MealyStep{Hangman.Print}(Hangman.Print("guessed right!"), Hangman.NeedInput("teste", "t__t_", 9)),
    MealyStep{Hangman.Print}(Hangman.Print("guessed right!"), Hangman.NeedInput("teste", "te_te", 9)),
    MealyStep{Hangman.Print}(Hangman.Print("you won!"), Hangman.EndGame(true)),
    MealyStep{Hangman.Print}(Hangman.Print("GAME OVER - you won"), Hangman.EndGame(true)),
]

in1 = "tesx"

@test scanleft(trans, MyChar.(collect(in1)), init=MealyStep(nothing,newgame("teste"))) == gt1

gt2 = [
    MealyStep{Nothing}(nothing, Hangman.NeedInput("teste", "_____", 9)),
    MealyStep{Hangman.Print}(Hangman.Print("guessed right!"), Hangman.NeedInput("teste", "_e__e", 9)),
    MealyStep{Hangman.Print}(Hangman.Print("guessed right!"), Hangman.NeedInput("teste", "te_te", 9)),
    MealyStep{Hangman.Print}(Hangman.Print("you're wrong, sir."), Hangman.NeedInput("teste", "te_te", 8)),
    MealyStep{Hangman.Print}(Hangman.Print("you're wrong, sir."), Hangman.NeedInput("teste", "te_te", 7)),
    MealyStep{Hangman.Print}(Hangman.Print("you won!"), Hangman.EndGame(true))
]

in2 = "etxqs"
@test scanleft(trans, MyChar.(collect(in2)), init=MealyStep(nothing,newgame("teste"))) == gt2


end
