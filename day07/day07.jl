function next_power_of_10(n)
    if n < 10
        return 10
    elseif n < 100
        return 100
    else
        return 1000
    end
end

function try_ops(line, target, idx, try_concat)
    v = line[idx]
    if idx == 1
        return v == target
    end

    if v > target
        return false
    end

    m = false
    if target % v == 0
        m = try_ops(line, div(target, v), idx-1, try_concat)
    end

    a = try_ops(line, target-v, idx-1, try_concat)

    if !try_concat
        return m || a
    end

    c = false
    np = next_power_of_10(v)
    n = target % np
    if n == v
        c = try_ops(line, div(target, np), idx-1, try_concat)
    end

    return m || a || c
end

function parse_input(input)
    p1 = 0
    p2 = 0
    res = Vector{Int64}()

    for line in split(input, "\n")
        s = split(line, ":")
        target = parse(Int64, s[1])
        for v in split(s[2])
            push!(res, parse(Int64, v))
        end
        if try_ops(res, target, length(res), false)
            p1 += target
            p2 += target
        elseif try_ops(res, target, length(res), true)
            p2 += target
        end
        empty!(res)
    end

    return (p1, p2)
end

function main()
    input = read("input.txt", String) |> strip
    p1, p2 = parse_input(input)
    println("Part 1: ", p1, "\nPart 2: ", p2)
end

main()
