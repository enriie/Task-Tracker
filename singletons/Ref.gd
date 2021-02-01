extends Node

enum TASK_TYPE { DAILY, WEEKLY, MONTHLY, ONE_TIME }
enum MANAGER_FILTERS { ALL, DAILY, WEEKLY, MONTHLY, ONE_TIME}

const KEY_TASK_NAME = "task_name"
const KEY_TASK_CHECKED = "checked"
const KEY_TASK_CHECKED_DATE = "checked_date"

const WAIT_TIME = 600
