module Hangman

abstract type State end
abstract type Transition end
abstract type Input end
abstract type Output end

struct MealyStep{R <: Union{Nothing, Output}}
    output::R
    state
end

struct NeedInput <: State
    solution :: String
    guess :: String
    lives :: Int
end

struct EndGame <: State
    scored :: Bool
end

newgame(word::String) = NeedInput(word, join('_' for _ in 1:length(word)), 9)

struct NewGame <: Input
    word::String
end

struct MyChar <: Input
    c::Char
end

struct Print <: Output
    msg
end

function trans(mystate::NeedInput, letter::MyChar)


    if letter.c in mystate.guess
        MealyStep(
            Print("already got it!"),
            mystate
        )
    elseif !(letter.c in mystate.solution)
        if mystate.lives>0
            MealyStep(
                Print("you're wrong, sir."),
                NeedInput(mystate.solution, mystate.guess, mystate.lives-1)
            )
        else
            MealyStep(
                Print("you're wrong, sir, and you're DEAD."),
                EndGame(false)
            )
        end
    else

        newguess = join(if a==b || a==letter.c a else '_' end for (a,b) in zip(mystate.solution, mystate.guess))

        if '_' in newguess
            MealyStep(
                Print("guessed right!"),
                NeedInput(mystate.solution, newguess, mystate.lives)
            )
        else
            MealyStep(
                Print("you won!"),
                EndGame(true)
            )
        end
    end
end

# trans(step ::S, inp ::I) where {S<:MealyStep{R<:Union{Nothing,Output}}, I<:Input}= trans(step.state, inp)

trans(step ::S, inp ::I) where {R <: Union{Nothing,Output}, S<:MealyStep{R}, I<:Input} = trans(step.state, inp)


function trans(mystate::EndGame, _)
    out = if mystate.scored
        Print("GAME OVER - you won")
    else
        Print("GAME OVER - you lost")
    end

    MealyStep(out, mystate)
end

function scanleft(op, col; init)
    out = Any[init]
    for el in col
        push!(out, op(out[end], el))
    end
    out
end

# function mealyscanleft(op, col; init)
#     out = MealyStep[MealyStep(nothing, init)]
#     for el in col
#         push!(out, op(out[end].state, el))
#     end
#     out
# end


# function processoutput(o::Print)
#     @info o.msg
# end

# function processmealymachine(st::S, l::I)::T where {S<:State, T<:State, I<:Input}
#     output, newstate = trans(st,l)
#     processoutput(output)
#     newstate
# end

end # module
