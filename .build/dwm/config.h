/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]            = "-*-monaco-*-*-*-*-10-*-*-*-*-*-*-*";

#define NUMCOLORS 8
static const char colors[NUMCOLORS][ColLast][8] = {
// border    foreground background
{ "#212121", "#696969", "#121212" }, // 0 = normal
{ "#696969", "#E0E0E0", "#121212" }, // 1 = selected
{ "#212121", "#BF4D80", "#121212" }, // 2 = red
{ "#212121", "#53A6A6", "#121212" }, // 3 = green
{ "#212121", "#A270A3", "#121212" }, // 4 = yellow
{ "#212121", "#6096BF", "#121212" }, // 5 = cyan
{ "#212121", "#7E62B3", "#121212" }, // 6 = magenta
{ "#212121", "#C0C0C0", "#121212" }, // 7 = white
};

static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 5;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
//static const char *tags[] = { "WEB", "CODE", "BOOK", "RELAX", "DESIGN", "ELSE"};
static const char *tags[] = { ".", ":", ".:", "::", ".::", ":::"};

static const Rule rules[] = {
    /* class      instance          title         tags mask     isfloating   monitor */
    { "Gimp",     NULL,             NULL,         NULL,         True,        -1 },
    { NULL,       "chromium",       NULL,         1 << 0,       False,       -1 },
    { NULL,       NULL,             "terminal",   1 << 1,       False,       -1 },
    { NULL,       NULL,             "jumanji",    1 << 0,       False,       -1 },
    { NULL,       NULL,             "pad",        NULL,         True,        -1 },
    { NULL,       "zathura",        NULL,         1 << 2,       False,       -1 }
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const Bool resizehints = True; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "{BH}",     bstackhoriz },
	{ "{T}",      tile },    /* first entry is default */
	{ "{F}",      NULL },    /* no layout function means floating behavior */
	{ "{M}",      monocle },
	{ "{BV}",     bstack }
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
static const char *dmenucmd[]      = { "dmenu_run", "-fn", font, "-nb", colors[0][ColBG], "-nf", colors[0][ColFG], "-sb", colors[1][ColBG], "-sf", colors[1][ColFG], NULL };
static const char *termcmd[]       = { "urxvtc", "-title", "terminal"};
static const char *browser[]       = { "jumanji", NULL };
static const char *pidgin[]        = { "pidgin", NULL };
static const char *gimp[]          = { "gimp", NULL };
static const char *music[]         = { "ncmpcpp", NULL };
static const char *unikey[]        = { "ibus-daemon", NULL };
static const char *volumeUp[]      = { "amixer set Master 5%+", NULL };
static const char *volumeDown[]    = { "amixer set Master 5%-", NULL };
static const char *volumeMute[]    = { "amixer set Master toggle", NULL };
static const char *ncmpcppToggle[] = { "ncmpcpp toggle", NULL };
static const char *ncmpcppStop[]   = { "ncmpcpp stop", NULL };
static const char *padcmd[]        = { "urxvtc", "-title", "pad", "-geometry", "70x12+730+24", NULL };

static Key keys[] = {
    /* modifier                     key        function        argument */
        // applications
    { MODKEY,                       XK_space,  spawn,          {.v = dmenucmd } },
    { Mod4Mask,                     XK_Return, spawn,          {.v = termcmd } },
    { Mod4Mask,                     XK_b,      spawn,          {.v = browser} },
    { Mod4Mask,                     XK_c,      spawn,          {.v = pidgin} },
    { Mod4Mask,                     XK_g,      spawn,          {.v = gimp} },
    { Mod4Mask,                     XK_m,      spawn,          {.v = music} },
    { Mod4Mask,                     XK_u,      spawn,          {.v = unikey} },
    { Mod4Mask,                     XK_p,      spawn,          {.v = padcmd} },
        // multimedia
    { 0,                      0x1008ff13,      spawn,          {.v = volumeUp} },
    { 0,                      0x1008ff11,      spawn,          {.v = volumeDown} },
    { 0,                      0x1008ff12,      spawn,          {.v = volumeMute} },
    { 0,                      0x1008ff14,      spawn,          {.v = ncmpcppToggle}},
    { 0,                      0x1008ff15,      spawn,          {.v = ncmpcppToggle}},

    { MODKEY,                       XK_b,      togglebar,      {0} },
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} }, 
    { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
    { MODKEY,                       XK_Return, zoom,           {0} },
    { MODKEY,                       XK_Tab,    view,           {0} },
    { MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
    { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[1]} },
    { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} },
    { MODKEY,                       XK_s,      setlayout,      {.v = &layouts[0]} },
    { MODKEY,                       XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    TAGKEYS(                        XK_6,                      5)
    TAGKEYS(                        XK_7,                      6)
    TAGKEYS(                        XK_8,                      7)
    TAGKEYS(                        XK_9,                      8)
    { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

