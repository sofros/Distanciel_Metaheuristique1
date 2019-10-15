nb = 4

#initialisation variables
x_a = zeros(Float64 , nb) ; v_a = zeros(Float64 , nb) ; p_a = zeros(Float64 , nb)
f_a = zeros(Float64, nb)
x_b = zeros(Float64 , nb) ; v_b = zeros(Float64 , nb) ; p_b = zeros(Float64 , nb)
f_b = zeros(Float64, nb)
g = zeros(Float64 , nb)

#intiialisation valeurs
rng = [0.679923 0.269864 0.88061 0.722799 0.566828 0.44927 0.935181 0.1669 0.29829 0.670977 0.369223 0.927932]
x_a[1] = 0.5 ; v_a[1] = 0
x_b[1] = 1.25 ; v_b[1] = 0
w = 1 ; c1 = 2 ; c2 = 2

function swarm(x_a,v_a,p_a,x_b,v_b,p_b,g,rng,w,c1,c2)
    cpt = 1
    for t in 1:nb
        push!(f_b, round(f(x_b[t]); digits = 4))
        if t != 1
            v_a[t] = velocite(w, v_a[t-1], rng[cpt], c1, p_a[t-1], x_a[t-1], rng[cpt + 1], c2, g[t-1])
            cpt += 2
            v_b[t] = velocite(w, v_b[t-1], rng[cpt], c1, p_b[t-1], x_b[t-1], rng[cpt + 1], c2, g[t-1])
            cpt += 2
            x_a[t] = position(x_a[t-1], v_a[t])
            x_b[t] = position(x_b[t-1], v_b[t])
        end
        f_a[t] = f(round(x_a[t];digits=4))
        f_b[t] = f(round(x_b[t];digits=4))
        p_a[t] = perso_max(x_a)
        p_b[t] = perso_max(x_b)
        g[t] = pos_max(x_a[t],x_b[t])
    end
    println("x_a: ", x_a) ; println("v_a: ", v_a) ; println("p_a: ", p_a)
    println("f_a: ", f_a)
    println("g: ", g)
    println("x_b: ", x_b); println("v_b: ", v_b); println("p_b: ", p_b)
    println("f_b: ", f_b)
end

function f(x)
    return(x*sin(pi*10*x)+1)
end

function velocite(w, v, rng1, c1, p, x, rng2, c2, g)
    return((w*v) + (rng1*c1*(p - x)) + (rng2*c2*(g - x)))
end

function position(x,v)
    return(x+v)
end

function pos_max(x1,x2)
    if f(x1)-f(x2) > 0
        return(x1)
    else
        return(x2)
    end
end

function perso_max(x)
    max = f(x[1])
    pos = 1
    for i in 2:length(x)
        if f(x[i]) > max
            max = f(x[i])
            pos = i
        end
    end
    return(x[pos])
end

swarm(x_a, v_a, p_a, x_b, v_b, p_b, g, rng, w, c1, c2)
