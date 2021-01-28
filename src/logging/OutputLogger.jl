struct OutputLogger{F,A}
    f::F
    logs::Vector{A}
    argidx::Int
end
# Accessors
func(l::OutputLogger) = l.f
logs(l::OutputLogger) = l.logs

# Constructors
OutputLogger(f::Function, ::Type{A}, idx) where A = OutputLogger{f,A}(f, A[], idx)
OutputLogger(f, ::Type{A}, idx) where A = OutputLogger{typeof(f),A}(f, A[], idx)

function(l::OutputLogger)(args...)
    ret = func(l)(args...)
    push!(logs(l), ret[l.argidx])
    return ret
end
