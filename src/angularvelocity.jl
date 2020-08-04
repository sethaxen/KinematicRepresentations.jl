struct AngularVelocity{T} <: FieldVector{3, T}
    x1::T
    x2::T
    x3::T
end
AngularVelocity(x1, x2, x3) = AngularVelocity(Base.promote(x1, x2, x3)...)

@inline (::Type{R})(ω::AngularVelocity) where {R<:RotationVec} = R(ω...)
@inline (::Type{R})(ω::AngularVelocity) where {R<:Rotation{3}} = R(RotationVec(ω))

@inline (::Type{T})(r::RotationVec) where {T<:AngularVelocity} = T(r.sx, r.sy, r.sz)
@inline (::Type{T})(r::Rotation{3}) where {T<:AngularVelocity} = T(RotationVec(r))

groupexp(ω::AngularVelocity) = RotationVec(ω)

grouplog(r::Rotation{3}) = AngularVelocity(r)

Rotations.rotation_angle(ω::AngularVelocity) = norm(ω)
