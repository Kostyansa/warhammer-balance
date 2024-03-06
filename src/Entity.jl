module Entity

struct Profile
    move::Int
    toughness::Int
    save::Int
    wounds::Int
    leadership::Int
    objective_control::Int
end;

struct Weapon
    range::Int
    attacks::Int
    skill::Int
    strength::Int
    armour_penetration::Int
    damage::Int
end;

mutable struct Model
    profile::Profile
    weapons::Vector{Weapon}
    wounds::Int
    #TODO modifiers
    Model(profile::Profile, weapons::Vector{Weapon}) = new(profile, weapons, profile.wounds)
end;

mutable struct Unit
    models::Vector{Model}
    last_hit::Union{Model, Nothing}
    last_index::Int
    Unit(models::Vector{Model}) = new(models, nothing, 0)
end;

function does_hit(model::Model, weapon::Weapon, roll::Int)::Bool
    (roll > weapon.skill) || ((roll == 6) && (roll != 1))
end

function does_wound(model::Model, weapon::Weapon, roll::Int)::Bool
    roll_needed = 5 - max(min(floor(weapon.strength / (model.profile.toughness / 2)), 4), 0);
    roll == 6 || (roll >= roll_needed)
end

function does_save(model::Model, weapon::Weapon, roll::Int)::Bool
    roll != 1 && ((roll - weapon.armour_penetration) >= model.profile.save)
end

function attack(attacker::Model, weapon::Weapon, defender::Unit)
    for _ in 1:weapon.attacks
        hit_roll = rand(1:6)
        if (!does_hit(attacker, weapon, hit_roll))
            return
        end

        if ((isnothing(defender.last_hit)) || (!is_alive(defender.last_hit)))
            if (is_alive(defender))
                break
            end
            defender.last_index += 1
            defender.last_hit = defender.models[defender.last_index]
        end

        last_hit = defender.last_hit

        wound_roll = rand(1:6)
        if (!does_wound(last_hit, weapon, wound_roll))
            return
        end

        save_roll = rand(1:6)
        if (does_save(last_hit, weapon, save_roll))
            return
        end

        last_hit.wounds -= weapon.damage
    end
end

function is_alive(model::Model)::Bool
    model.wounds > 0
end

function is_alive(defender::Unit)::Bool
    return any(model -> is_alive(model), defender.models)
end

# @with_kw struct Player
#     roster::Vector{Unit}
#     luck::Union{AbstarctRNG, Nothing} = nothing
# end

end