Cassette.@context MetaheuristicLogging

function Cassette.overdub(ctx::MetaheuristicLogging, f::typeof(Polya.Δ), args...)
    logger = ctx.metadata
    ret = @timed f(args...)
    log!(logger, args[2], first(ret)[2], ret[2])
    return first(ret)
end