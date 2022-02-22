using Plots

function lineplot(st::SearchTrace, xdata::Symbol, ydata::Symbol; kwargs...)
    return plot(st.df[:, xdata], st.df[:, ydata]; kwargs...)
end

function objective_plot(st::SearchTrace, xsym::Symbol=:it, ysym::Symbol=:v_s; kwargs...)
    return lineplot(st, xsym, ysym; kwargs...)
end