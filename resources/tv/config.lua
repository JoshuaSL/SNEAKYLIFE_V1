Config = {}

Config['URL'] = 'https://www.youtube.com/embed/%s?autoplay=1&controls=1&disablekb=1&fs=0&rel=0&showinfo=0&iv_load_policy=3&start=%s'

Config['API'] = {
    ['URL'] = 'https://www.googleapis.com/youtube/v3/videos?id=%s&part=contentDetails&key=%s',
    ['Key'] = ''
}
Config['DurationCheck'] = false

Config['Objects'] = {
    {
        ['Object'] = 'prop_tv_flat_01',
        ['Scale'] = 0.05,
        ['Offset'] = vec3(-0.925, -0.055, 1.0),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_michael',
        ['Scale'] = 0.035,
        ['Offset'] = vec3(-0.675, -0.055, 0.4),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_trev_tv_01',
        ['Scale'] = 0.012,
        ['Offset'] = vec3(-0.225, -0.01, 0.26),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_03b',
        ['Scale'] = 0.016,
        ['Offset'] = vec3(-0.3, -0.062, 0.18),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_03',
        ['Scale'] = 0.016,
        ['Offset'] = vec3(-0.3, -0.01, 0.4),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02b',
        ['Scale'] = 0.026,
        ['Offset'] = vec3(-0.5, -0.012, 0.525),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02',
        ['Scale'] = 0.026,
        ['Offset'] = vec3(-0.5, -0.012, 0.525),
        ['Distance'] = 9.5,
    },
    {
        ['Object'] = 'prop_tv_flat_02',
        ['Scale'] = 0.026,
        ['Offset'] = vec3(-0.5, -0.012, 0.525),
        ['Distance'] = 9.5,
    },
}