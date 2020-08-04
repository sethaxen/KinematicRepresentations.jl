module KinematicRepresentations

using LinearAlgebra, StaticArrays, Rotations, CoordinateTransformations

include("motion.jl")
include("angularvelocity.jl")
include("twist.jl")

export RigidMotion, AngularVelocity, Twist
export groupexp, grouplog

end
