/* See LICENSE file for copyright and license details. */

#define NUMCOLORS 4
static const char colors[NUMCOLORS][ColLast][8] = {
    // border   foreground background
    { "#000033", "#dddddd", "#000033" },  // normal
    { "#000088", "#ffffff", "#000088" },  // selected
    { "#ff0000", "#000000", "#ffff00" },  // urgent/warning  (black on yellow)
    { "#ff0000", "#ffffff", "#ff0000" },  // error (white on red)
    // add more here
}; 



/* appearance */
static const char font[]            = "Monaco 9";
static const char normbordercolor[] = "#212121";
static const char normbgcolor[]     = "#2E3436";
static const char normfgcolor[]     = "#696969";
static const char selbordercolor[]  = "#696969";
static const char selbgcolor[]      = "#2E3436";
static const char selfgcolor[]      = "#E0E0E0";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 5;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
//static const char *tags[] = { "WEB", "CODE", "BOOK", "RELAX", "DESIGN", "ELSE"};
static const char *tags[] = { ".", ":", ".:", "::", ".::", ":::"};

static const Rule rules[] = {
    /* class      instance    title       tags mask     isfloating   monitor */
    { "Gimp",     NULL,       NULL,       NULL,         True,        -1 },
    { NULL,       "chromium", NULL,       1 << 1,       False,       -1 },
    { NULL,       NULL,       "terminal", 1 << 2,       False,       -1 },
    { NULL,       "jumanji",  NULL,       1 << 1,       False,       -1 },
    { NULL,       "zathura",  NULL,       1 << 2,       True,        -1 }
};
/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const Bool resizehints = True; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "{T}",      tile },    /* first entry is default */
	{ "{F}",      NULL },    /* no layout function means floating behavior */
	{ "{M}",      monocle },
	{ "{BV}",     bstack },
	{ "{BH}",     bstackhoriz }
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
static const char *dmenucmd[]      = { "dmenu_run", "-fn", font, "-nb",     normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]       = { "urxvt", "-title", "terminal", "-    e" , "tmux" , "attach" , "-d" , "-t0" , NULL };
static const char *chrome[]        = { "chromium-dev", NULL };
static const char *pidgin[]        = { "pidgin", NULL };
static const char *gimp[]          = { "gimp", NULL };
static const char *music[]         = { "ncmpcpp", NULL };
static const char *unikey[]        = { "ibus-daemon", NULL };
static const char *volumeUp[]      = { "amixer set Master 5%+", NULL };
static const char *volumeDown[]    = { "amixer set Master 5%-", NULL };
static const char *volumeMute[]    = { "amixer set Master toggle", NULL };
static const char *ncmpcppToggle[] = { "ncmpcpp toggle", NULL };
static const char *ncmpcppStop[]   = { "ncmpcpp stop", NULL };


static Key keys[] = {
    /* modifier                     key        function        argument */
        // applications
    { MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
    { MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
    { MODKEY|ShiftMask,             XK_b,      spawn,          {.v = chrome} },
    { MODKEY|ShiftMask,             XK_p,      spawn,          {.v = pidgin} },
    { MODKEY|ShiftMask,             XK_g,      spawn,          {.v = gimp} },
    { MODKEY|ShiftMask,             XK_m,      spawn,          {.v = music} },
    { MODKEY|ShiftMask,             XK_v,      spawn,          {.v = unikey} },
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
    { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
    { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
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

