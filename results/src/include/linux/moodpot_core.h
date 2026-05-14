/* SPDX-License-Identifier: GPL-2.0 */
#ifndef _MOODPOT_CORE_DEF_H
#define	_MOODPOT_CORE_DEF_H

#define CMD_CREATE_POT       0x10
#define CMD_DELETE_POT       0x11
#define CMD_DELETE_ALL_POTS  0x12
#define CMD_SENSOR_UPDATE    0x01
#define CMD_REQUEST_STATE    0x02
#define CMD_RESET_STATE      0x03

#define SENSOR_MOISTURE      0x05
#define SENSOR_LIGHT         0x06
#define SENSOR_PROXIMITY     0x07
#define SENSOR_TEMPERATURE   0x08
#define SENSOR_VIBRATION     0x09

enum error_state {
    _SUCCESS      = 0x00,
    ALLOC_FAILED  = 0x01,
    INVALID_CMD_TYPE,
    INVALID_POT_ID,
    INVALID_SENSOR_ID,


};

#define MOOD_LEN             64
#define MOODPOT_RESP_MAX     512
#define MAX_BUF_SIZE         MOODPOT_RESP_MAX 

struct response {
    char resp_buf[MAX_BUF_SIZE];
    size_t resp_len;
    struct mutex resp_lock;
};

struct moodpot_response {
	int result;
	int pot_id;
	uint8_t mood[MOOD_LEN];
};

struct moodpot_cmd {
    uint8_t cmd_type;
    uint8_t sensor_id;
    uint16_t value;
    uint8_t version;
    uint8_t reserved[51];
} __packed;

struct moodpot_usercmd {
    int pot_id;
    struct moodpot_cmd cmd;
} __packed;

int evaluate_usercmd(struct moodpot_usercmd *, struct response *);

#endif