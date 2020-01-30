"""
        default_settings()

Use this to load default settings in the `SETTINGS`-keyword.
"""
function default_settings()
    return (DEFAULT_COLOR = RGBA(0,0,0,1),
            BG_COLOR = RGBA(0,.2,0,0),
            BLOCK_BG_COLOR = RGBA(1,1,1,1),
            COLOR_INACTIVE = RGBA(.4,.4,.4,1),
            COLOR_ACTIVE = RGBA(.6,0,0,1),
            CONN_W_INACTIVE = 3,
            CONN_W_ACTIVE = 4,
            OP_NCOLORS = 100,
            OP_COLORMAP = "RdBu",
            T_COLORMAP = range(RGB(1,0,0), stop=RGB(0,1,0), length=100)
            )
end
