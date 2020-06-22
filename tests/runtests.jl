using Pkg; Pkg.activate("/home/user/src/Hangman")

using Hangman

import Hangman: trans, newgame, scanleft, MyChar, MealyStep, Output, Input, MsgEmpty

using Test

@testset "All tests" begin

    # proc(s,c) = trans(s,c).state

    # foldl(proc, MyChar.(['e', 't', 'x', 'q', 's']), init=newgame("teste"))

    gt1 = [
        MealyStep(MsgEmpty(), Hangman.NeedInput("teste", "_____", 9)),
        MealyStep(Hangman.MsgRight(), Hangman.NeedInput("teste", "t__t_", 9)),
        MealyStep(Hangman.MsgRight(), Hangman.NeedInput("teste", "te_te", 9)),
        MealyStep(Hangman.MsgWon(), Hangman.EndGame(true)),
        MealyStep(Hangman.MsgGameOverWon(), Hangman.EndGame(true)),
    ]

    in1 = "tesx"

    @test scanleft(trans, MyChar.(collect(in1)), init=MealyStep(MsgEmpty(), newgame("teste"))) == gt1

    gt2 = [
        MealyStep(MsgEmpty, Hangman.NeedInput("teste", "_____", 9)),
        MealyStep(Hangman.Print("guessed right!"), Hangman.NeedInput("teste", "_e__e", 9)),
        MealyStep(Hangman.Print("guessed right!"), Hangman.NeedInput("teste", "te_te", 9)),
        MealyStep(Hangman.Print("you're wrong, sir."), Hangman.NeedInput("teste", "te_te", 8)),
        MealyStep(Hangman.Print("you're wrong, sir."), Hangman.NeedInput("teste", "te_te", 7)),
        MealyStep(Hangman.Print("you won!"), Hangman.EndGame(true))
    ]

    in2 = "etxqs"
    @test scanleft(trans, MyChar.(collect(in2)), init=MealyStep(MsgEmpty(), newgame("teste"))) == gt2


end
