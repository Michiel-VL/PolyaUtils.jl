struct InputLogger{F,A}
    f::F
    logs::Vector{A}
    argidx::Int
end

# Accessors
func(l::InputLogger) = l.f
logs(l::InputLogger) = l.logs

# Constructors
InputLogger(f::Function, ::Type{A}, idx) where A = InputLogger{f,A}(f, A[],idx)
InputLogger(f, ::Type{A}, idx) where A = InputLogger{typeof(f),A}(f, A[], idx)
# Functionality
function (l::InputLogger)(args...)
    log = args[l.argidx]
    push!(l.logs, log)
    return func(l)(args...)
end

Base.empty!(l::InputLogger) = empty!(l.logs)