module Hangman


abstract type State end

abstract type Transition end

abstract type Input end

abstract type Output end

struct MealyStep{R <: Output, S <: State}
    output::R
    state::S
end

struct NeedInput <: State
    solution :: String
    guess :: String
    lives :: Int
end

newgame(word::String) = NeedInput(word, join('_' for _ in 1:length(word)), 9)

struct EndGame <: State
    laststate :: State
    scored :: Bool
end

struct NewGame <: Input
    word::String
end

struct NoGame <: Input
end

struct CharGuess <: Input
    c::String
end

struct MsgEmpty <: Output end
struct MsgGotIt <: Output end
struct MsgWrong <: Output end
struct MsgRight <: Output end
struct MsgNewGame <: Output end
struct MsgGameOverWon <: Output end
struct MsgGameOverLost <: Output end

function trans(mystate::NeedInput, letter::CharGuess)

    if length(letter.c) != 1
        MealyStep(
            MsgEmpty(),
            mystate
        )
    else
        c = letter.c[1]
        if c in mystate.guess
            MealyStep(
                MsgGotIt(),
                mystate
            )
        elseif !(c in mystate.solution)
            if mystate.lives>1
                MealyStep(
                    MsgWrong(),
                    NeedInput(mystate.solution, mystate.guess, mystate.lives-1)
                )
            else
                MealyStep(
                    MsgGameOverLost(),
                    EndGame(NeedInput(mystate.solution, mystate.guess, mystate.lives-1), false)
                )
            end
        else
            newguess = join(if a==b || a==c a else '_' end for (a,b) in zip(mystate.solution, mystate.guess))

            if '_' in newguess
                MealyStep(
                    MsgRight(),
                    NeedInput(mystate.solution, newguess, mystate.lives)
                )
            else
                MealyStep(
                    MsgGameOverWon(),
                    EndGame(NeedInput(mystate.solution, newguess, mystate.lives), true)
                )
            end
        end
    end
end

"""If a MealyStep is used instead of the state, fetch the state from within it."""
trans(step ::S, inp ::I) where {R <: Output, S<:MealyStep{R}, I<:Input} = trans(step.state, inp)


function trans(_, ng::NewGame)
    MealyStep(MsgNewGame(), newgame(ng.word))
end

function trans(mystate::EndGame, ng::NewGame)
    MealyStep(MsgNewGame(), newgame(ng.word))
end

function trans(mystate::EndGame, _)
    out = if mystate.scored
        MsgGameOverWon()
    else
        MsgGameOverLost()
    end

    MealyStep(out, mystate)
end


function scanleft(op, col; init)
    out = Any[init]  # Type should be the same as the left input and output of `op`
    for el in col
        push!(out, op(out[end], el))
    end
    out
end


end # module
