/**
 * Author......: See docs/credits.txt
 * License.....: MIT
 */

//#define NEW_SIMD_CODE

#ifdef KERNEL_STATIC
#include "inc_vendor.h"
#include "inc_types.h"
#include "inc_platform.cl"
#include "inc_common.cl"
#include "inc_rp.h"
#include "inc_rp.cl"
#include "inc_scalar.cl"
#include "inc_hash_md5.cl"
#endif

KERNEL_FQ void m92100_mxx (KERN_ATTR_RULES ())
{
  /**
   * modifier
   */

  const u64 lid = get_local_id (0);
  const u64 gid = get_global_id (0);

  if (gid >= gid_max) return;

  /**
   * base
   */

  COPY_PW (pws[gid]);

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < il_cnt; il_pos++)
  {
    pw_t tmp = PASTE_PW;

    tmp.pw_len = apply_rules (rules_buf[il_pos].cmds, tmp.i, tmp.pw_len);

    md5_ctx_t ctx;

    md5_init (&ctx);

    md5_update (&ctx, tmp.i, tmp.pw_len);

    md5_final (&ctx);

    const u32 r0 = ctx.h[DGST_R0] & 0xFFFFFF00;
    const u32 r1 = ctx.h[DGST_R1];

    const u32 z = 0;

    COMPARE_M_SCALAR (r0, r1, z, z);
  }
}

KERNEL_FQ void m92100_sxx (KERN_ATTR_RULES ())
{
  /**
   * modifier
   */

  const u64 lid = get_local_id (0);
  const u64 gid = get_global_id (0);

  if (gid >= gid_max) return;

  /**
   * digest
   */

  const u32 search[4] =
  {
    digests_buf[DIGESTS_OFFSET].digest_buf[DGST_R0],
    digests_buf[DIGESTS_OFFSET].digest_buf[DGST_R1],
    digests_buf[DIGESTS_OFFSET].digest_buf[DGST_R2],
    digests_buf[DIGESTS_OFFSET].digest_buf[DGST_R3]
  };

  /**
   * base
   */

  COPY_PW (pws[gid]);

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < il_cnt; il_pos++)
  {
    pw_t tmp = PASTE_PW;

    tmp.pw_len = apply_rules (rules_buf[il_pos].cmds, tmp.i, tmp.pw_len);

    md5_ctx_t ctx;

    md5_init (&ctx);

    md5_update (&ctx, tmp.i, tmp.pw_len);

    md5_final (&ctx);

    const u32 r0 = ctx.h[DGST_R0] & 0xFFFFFF00;
    const u32 r1 = ctx.h[DGST_R1];

    const u32 z = 0;

    COMPARE_S_SCALAR (r0, r1, z, z);
  }
}
