#define CMDLENGTH 45
#define DELIMITER "  "
#define CLICKABLE_BLOCKS

/* update block my run `kill -((34+signal)) $(pidof dwmblocks)` */

const Block blocks[] = {
	    /* command     interval signal */
	// BLOCK("sb-pacman",    0,    27),
	BLOCK("sb-tailscale", 5,    28),
	BLOCK("sb-uptime",    5,    25),
	// BLOCK("sb-ibus",      5,    26),
	BLOCK("sb-mem",       5,    24),
	BLOCK("sb-vol",       0,    21),
	BLOCK("sb-date",      5,    20),
};
