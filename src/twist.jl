struct Twist{T} <: StaticVector{6,T}
    angular::AngularVelocity{T}
    linear::SVector{3,T}
end
function (::Type{T})(xs::NTuple{6}) where {T<:Twist}
    (x1, x2, x3, x4, x5, x6) = Base.promote(xs...)
    ω = AngularVelocity{typeof(x1)}(x1, x2, x3)
    v = SVector{3,typeof(x4)}(x4, x5, x6)
    return T(ω, v)
end

Base.@propagate_inbounds function Base.getindex(x::Twist, i::Int)
    return i < 4 ? getindex(x.angular, i) : getindex(x.linear, i - 3)
end

@inline Base.Tuple(t::Twist) = (Tuple(t.angular)..., Tuple(t.linear)...)

function groupexp(t::Twist)
    ω, b = t.angular, t.linear
    θ = rotation_angle(ω)
    rotation = groupexp(t.angular)
    translation = if iszero(θ)
        b
    else
        sinθ, cosθ = sincos(θ)
        θ² = θ^2
        p₁, p₂ = (1 - cosθ) / θ², (1 - sinθ / θ) / θ²
        ωxb = cross(ω, b)
        b + p₁ * ωxb + p₂ * cross(ω, ωxb)
    end
    return AffineMap(rotation, translation)
end

function grouplog(x::RigidMotion{3})
    r, t = x.linear, x.translation
    angular = grouplog(r)
    θ = rotation_angle(angular)
    linear = if iszero(θ)
        t
    else
        sinθ, cosθ = sincos(θ)
        θ² = θ^2
        p₂ = 1 / θ² - (1 + cosθ) / 2 / θ / sinθ
        ωxt = cross(angular, t)
        t - ωxt / 2 + p₂ * cross(angular, ωxt)
    end
    return Twist(angular, linear)
end
