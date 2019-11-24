#include <string.h>
#include <stdint.h>

/**
 * memset - Fill a region of memory with the given value
 * @s: Pointer to the start of the area.
 * @c: The byte to fill the area with
 * @count: The size of the area.
 *
 * Do not use memset() to access IO space, use memset_io() instead.
 */
void *memset(void *s, int c, size_t count)
{
	char *xs = s;

	while (count--)
		*xs++ = c;
	return s;
}

void *memset16(void *s, int c, size_t count) {
	int16_t *xs = s;
	while (count--) {
		*(xs++) = c;
	}
	return s;
}