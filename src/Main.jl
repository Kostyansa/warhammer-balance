using Parameters
using Random
include("entity.jl")

hearthkyn_warrior = Entity.Profile(5, 5, 4, 1, 7, 2)
autoch_pattern_bolter = Entity.Weapon(24, 2, 4, 4, 0, 1)

strike_team = Entity.Profile(6, 3, 4, 1, 7, 2)
pulse_carbine = Entity.Weapon(20, 2, 4, 5, 0, 1)

hearthkyn_warrior = Entity.Profile(5, 5, 4, 1, 7, 2)
autoch_pattern_bolter = Entity.Weapon(24, 2, 4, 4, 0, 1)

strike_team = Entity.Profile(6, 3, 4, 1, 7, 2)
pulse_carbine = Entity.Weapon(20, 2, 4, 5, 0, 1)

wins = [0, 0]
simulations = 10000
rounds = 0

for _ in 1:simulations
    unit_hearthkyn = Entity.Unit([Entity.Model(hearthkyn_warrior, [autoch_pattern_bolter]) for _ in 1:10])
    unit_strike_team = Entity.Unit([Entity.Model(strike_team, [pulse_carbine]) for _ in 1:10])

    players = [unit_hearthkyn, unit_strike_team]
    to_play = rand(0:length(players) - 1)
    
    while all(Entity.is_alive, players)
        global rounds
        rounds += 1

        defender_index = (to_play + 1) % length(players)
        defender = players[defender_index + 1]

        for attacker in players[to_play + 1].models
            if (!Entity.is_alive(attacker))
                continue
            end
            if (!Entity.is_alive(defender))
                break
            end

            weapon = rand(attacker.weapons)
            Entity.attack(attacker, weapon, defender)
        end

        to_play = (to_play + 1) % length(players)
    end

    if (Entity.is_alive(players[1]))
        wins[1] += 1
    elseif (Entity.is_alive(players[2]))
        wins[2] += 1
    end
end

println(wins)
println(rounds/simulations)