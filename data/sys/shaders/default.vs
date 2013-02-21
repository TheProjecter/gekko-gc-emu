#ifndef _VSDEF_COLOR0_MATERIAL_SRC
#define _VSDEF_COLOR0_MATERIAL_SRC vec4(1.0f, 1.0f, 1.0f, 1.0f)
#endif

#ifndef _VSDEF_COLOR1_MATERIAL_SRC
#define _VSDEF_COLOR1_MATERIAL_SRC vec4(1.0f, 1.0f, 1.0f, 1.0f)
#endif

#ifndef _VSDEF_COLOR0_AMBIENT_SRC
#define _VSDEF_COLOR0_AMBIENT_SRC vec4(1.0f, 1.0f, 1.0f, 1.0f)
#endif

#ifndef _VSDEF_COLOR1_AMBIENT_SRC
#define _VSDEF_COLOR1_AMBIENT_SRC vec4(1.0f, 1.0f, 1.0f, 1.0f)
#endif

#ifndef _VSDEF_SET_CHAN0_LIGHT0
#define _VSDEF_SET_CHAN0_LIGHT0
#endif

#ifndef _VSDEF_SET_CHAN0_LIGHT1
#define _VSDEF_SET_CHAN0_LIGHT1
#endif

#ifndef _VSDEF_SET_CHAN0_LIGHT2
#define _VSDEF_SET_CHAN0_LIGHT2
#endif

#ifndef _VSDEF_SET_CHAN0_LIGHT3
#define _VSDEF_SET_CHAN0_LIGHT3
#endif

#ifndef _VSDEF_SET_CHAN0_LIGHT4
#define _VSDEF_SET_CHAN0_LIGHT4
#endif

#ifndef _VSDEF_SET_CHAN0_LIGHT5
#define _VSDEF_SET_CHAN0_LIGHT5
#endif

#ifndef _VSDEF_SET_CHAN0_LIGHT6
#define _VSDEF_SET_CHAN0_LIGHT6
#endif

#ifndef _VSDEF_SET_CHAN0_LIGHT7
#define _VSDEF_SET_CHAN0_LIGHT7
#endif

#ifndef _VSDEF_SET_CHAN1_LIGHT0
#define _VSDEF_SET_CHAN1_LIGHT0
#endif                 
                       
#ifndef _VSDEF_SET_CHAN1_LIGHT1
#define _VSDEF_SET_CHAN1_LIGHT1
#endif                 
                       
#ifndef _VSDEF_SET_CHAN1_LIGHT2
#define _VSDEF_SET_CHAN1_LIGHT2
#endif                 
                       
#ifndef _VSDEF_SET_CHAN1_LIGHT3
#define _VSDEF_SET_CHAN1_LIGHT3
#endif                 
                       
#ifndef _VSDEF_SET_CHAN1_LIGHT4
#define _VSDEF_SET_CHAN1_LIGHT4
#endif                 
                       
#ifndef _VSDEF_SET_CHAN1_LIGHT5
#define _VSDEF_SET_CHAN1_LIGHT5
#endif                 
                       
#ifndef _VSDEF_SET_CHAN1_LIGHT6
#define _VSDEF_SET_CHAN1_LIGHT6
#endif                 
                       
#ifndef _VSDEF_SET_CHAN1_LIGHT7
#define _VSDEF_SET_CHAN1_LIGHT7
#endif

layout(location = 0) in vec3 position;
layout(location = 1) in vec4 color0;
layout(location = 2) in vec4 color1;
layout(location = 3) in vec4 normal;

layout(location = 4)  in vec4 texcoord0;
layout(location = 5)  in vec4 texcoord1;
layout(location = 6)  in vec4 texcoord2;
layout(location = 7)  in vec4 texcoord3;
layout(location = 8)  in vec4 texcoord4;
layout(location = 9)  in vec4 texcoord5;
layout(location = 10) in vec4 texcoord6;
layout(location = 11) in vec4 texcoord7;

layout(location = 12) in vec4 matrix_idx_pos;
layout(location = 13) in vec4 matrix_idx_tex03;
layout(location = 14) in vec4 matrix_idx_tex47;

struct Light {
    vec4 col; 
    vec4 cos_atten; 
    vec4 dist_atten; 
    vec4 pos; 
    vec4 dir;
};

struct VertexState {
    float   cp_pos_dqf; 
    int     cp_pos_matrix_offset;
    float   pad0;
    float   pad1;
    vec4    cp_tex_dqf[2];
    ivec4   cp_tex_matrix_offset[2];
    mat4    projection_matrix;
    vec4    xf_material_color[2];
    vec4    xf_ambient_color[2];
    Light   light[8]; 
};

// XF memory
layout(std140) uniform _VS_UBO {
    VertexState state;
    vec4 tf_mem[0x40];
    vec4 nrm_mem[0x20]; // vec4 for tight packing (normal is just using xyz)
};

// Vertex shader outputs
out vec4 vtx_color[2];
out vec2 vtx_texcoord[8];

#define TF_MEM_MTX44(addr) mat4( \
    tf_mem[addr].x, tf_mem[addr + 1].x, tf_mem[addr + 2].x, 0.0, \
    tf_mem[addr].y, tf_mem[addr + 1].y, tf_mem[addr + 2].y, 0.0, \
    tf_mem[addr].z, tf_mem[addr + 1].z, tf_mem[addr + 2].z, 0.0, \
    tf_mem[addr].w, tf_mem[addr + 1].w, tf_mem[addr + 2].w, 1.0)

void main() {
    vec4 pos;
    vec4 nrm;
    vec4 mat[2];
    vec4 l_amb[2];
    vec4 col[2];
    
    vec3 N0, N1, N2;
    
    mat[0]      = _VSDEF_COLOR0_MATERIAL_SRC;
    mat[1]      = _VSDEF_COLOR1_MATERIAL_SRC;
    l_amb[0]    = _VSDEF_COLOR0_AMBIENT_SRC;
    l_amb[1]    = _VSDEF_COLOR1_AMBIENT_SRC;
    
    mat4 modelview_matrix;
#ifdef _VSDEF_POS_MIDX // Position modelview matrix
    modelview_matrix = TF_MEM_MTX44(int(matrix_idx_pos[0]));
    
    int nrm_matrix_offset = int(matrix_idx_pos[0]);
    if (state.cp_pos_matrix_offset >= 32) {
        nrm_matrix_offset -= 32;
    }
    N0 = nrm_mem[nrm_matrix_offset + 0].xyz;
    N1 = nrm_mem[nrm_matrix_offset + 1].xyz;
    N2 = nrm_mem[nrm_matrix_offset + 2].xyz;
#else
    modelview_matrix = TF_MEM_MTX44(state.cp_pos_matrix_offset);
    
    int nrm_matrix_offset = state.cp_pos_matrix_offset;
    if (state.cp_pos_matrix_offset >= 32) {
        nrm_matrix_offset -= 32;
    }
    N0 = nrm_mem[nrm_matrix_offset + 0].xyz;
    N1 = nrm_mem[nrm_matrix_offset + 1].xyz;
    N2 = nrm_mem[nrm_matrix_offset + 2].xyz;
#endif
#ifdef _VSDEF_POS_DQF // Position shift (dequantization factor) only U8/S8/U16/S16 formats
    pos = state.projection_matrix * modelview_matrix * 
        vec4(position.xyz * state.cp_pos_dqf, 1.0);
#else
    pos = state.projection_matrix * modelview_matrix * vec4(position.xyz, 1.0);
#endif
    nrm.xyz = normalize(vec3(dot(N0, normal.xyz), dot(N1, normal.xyz), dot(N2, normal.xyz)));

#ifdef _VSDEF_TEX_0_MIDX // Texture coord 0
    vtx_texcoord[0] = vec4(TF_MEM_MTX44(int(matrix_idx_tex03[0])) * 
        vec4(texcoord0.st * state.cp_tex_dqf[0][0], 0.0f, 1.0f)).st;
#else
    vtx_texcoord[0] = vec4(TF_MEM_MTX44(state.cp_tex_matrix_offset[0][0]) * 
        vec4(texcoord0.st * state.cp_tex_dqf[0][0], 0.0f, 1.0f)).st;
#endif
#ifdef _VSDEF_TEX_1_MIDX // Texture coord 1
    vtx_texcoord[1] = vec4(TF_MEM_MTX44(int(matrix_idx_tex03[1])) * 
        vec4(texcoord1.st * state.cp_tex_dqf[0][1], 0.0f, 1.0f)).st;
#else
    vtx_texcoord[1] = vec4(TF_MEM_MTX44(state.cp_tex_matrix_offset[0][1]) * 
        vec4(texcoord1.st * state.cp_tex_dqf[0][1], 0.0f, 1.0f)).st;
#endif
#ifdef _VSDEF_TEX_2_MIDX // Texture coord 2
    vtx_texcoord[2] = vec4(TF_MEM_MTX44(int(matrix_idx_tex03[2])) * 
        vec4(texcoord2.st * state.cp_tex_dqf[0][2], 0.0f, 1.0f)).st;
#else
    vtx_texcoord[2] = vec4(TF_MEM_MTX44(state.cp_tex_matrix_offset[0][2]) * 
        vec4(texcoord2.st * state.cp_tex_dqf[0][2], 0.0f, 1.0f)).st;
#endif
#ifdef _VSDEF_TEX_3_MIDX // Texture coord 3
    vtx_texcoord[3] = vec4(TF_MEM_MTX44(int(matrix_idx_tex03[3])) * 
        vec4(texcoord3.st * state.cp_tex_dqf[0][3], 0.0f, 1.0f)).st;
#else
    vtx_texcoord[3] = vec4(TF_MEM_MTX44(state.cp_tex_matrix_offset[0][3]) * 
        vec4(texcoord3.st * state.cp_tex_dqf[0][3], 0.0f, 1.0f)).st;
#endif
#ifdef _VSDEF_TEX_4_MIDX // Texture coord 4
    vtx_texcoord[4] = vec4(TF_MEM_MTX44(int(matrix_idx_tex47[0])) * 
        vec4(texcoord4.st * state.cp_tex_dqf[1][0], 0.0f, 1.0f)).st;
#else
    vtx_texcoord[4] = vec4(TF_MEM_MTX44(state.cp_tex_matrix_offset[1][0]) * 
        vec4(texcoord4.st * state.cp_tex_dqf[1][0], 0.0f, 1.0f)).st;
#endif
#ifdef _VSDEF_TEX_5_MIDX // Texture coord 5
    vtx_texcoord[5] = vec4(TF_MEM_MTX44(int(matrix_idx_tex47[1])) * 
        vec4(texcoord5.st * state.cp_tex_dqf[1][1], 0.0f, 1.0f)).st;
#else
    vtx_texcoord[5] = vec4(TF_MEM_MTX44(state.cp_tex_matrix_offset[1][1]) * 
        vec4(texcoord5.st * state.cp_tex_dqf[1][1], 0.0f, 1.0f)).st;
#endif
#ifdef _VSDEF_TEX_6_MIDX // Texture coord 6
    vtx_texcoord[6] = vec4(TF_MEM_MTX44(int(matrix_idx_tex47[2])) * 
        vec4(texcoord6.st * state.cp_tex_dqf[1][2], 0.0f, 1.0f)).st;
#else
    vtx_texcoord[6] = vec4(TF_MEM_MTX44(state.cp_tex_matrix_offset[1][2]) * 
        vec4(texcoord6.st * state.cp_tex_dqf[1][2], 0.0f, 1.0f)).st;
#endif
#ifdef _VSDEF_TEX_7_MIDX // Texture coord 7
    vtx_texcoord[7] = vec4(TF_MEM_MTX44(int(matrix_idx_tex47[3])) * 
        vec4(texcoord7.st * state.cp_tex_dqf[1][3], 0.0f, 1.0f)).st;
#else
    vtx_texcoord[7] = vec4(TF_MEM_MTX44(state.cp_tex_matrix_offset[1][3]) * 
        vec4(texcoord7.st * state.cp_tex_dqf[1][3], 0.0f, 1.0f)).st;
#endif
    
    // Vertex color 0
#ifdef _VSDEF_COLOR0_RGB565
    col[0].r = float(int(color0[1]) >> 3) / 31.0f;
    col[0].g = float(((int(color0[1]) & 0x7) << 3) | (int(color0[0]) >> 5)) / 63.0f;
    col[0].b = float(int(color0[0]) & 0x1F) / 31.0f;
    col[0].a = 1.0f;
#elif defined(_VSDEF_COLOR0_RGB8)
    col[0] = vec4(clamp((color0.rgb / 255.0f), 0.0, 1.0), 1.0);
#elif defined(_VSDEF_COLOR0__RGBX8)
    col[0] = vec4(clamp((color0.abg / 255.0f), 0.0, 1.0), 1.0);
#elif defined(_VSDEF_COLOR0_RGBA4)
    col[0].r = float(int(color0[1]) >> 4) / 15.0f;
    col[0].g = float(int(color0[1]) & 0xF) / 15.0f;
    col[0].b = float(int(color0[0]) >> 4) / 15.0f;
    col[0].a = float(int(color0[0]) & 0xF) / 15.0f;
#elif defined(_VSDEF_COLOR0_RGBA6)
    col[0].r = float(int(color0[0]) >> 2) / 63.0f;
    col[0].g = float(((int(color0[0]) & 0x3) << 4) | (int(color0[1]) >> 4)) / 63.0f;
    col[0].b = float(((int(color0[1]) & 0xF) << 2) | (int(color0[2]) >> 6)) / 63.0f;
    col[0].a = float(int(color0[2]) & 0x3F) / 63.0f;
#elif defined(_VSDEF_COLOR0_RGBA8)
    col[0] = clamp((color0.abgr / 255.0f), 0.0, 1.0);
#else
    col[0] = vec4(1.0, 1.0, 1.0, 1.0);
#endif
    // Vertex color 1
#ifdef _VSDEF_COLOR1_RGB565
    col[1].r = float(int(color1[1]) >> 3) / 31.0f;
    col[1].g = float(((int(color1[1]) & 0x7) << 3) | (int(color1[0]) >> 5)) / 63.0f;
    col[1].b = float(int(color1[0]) & 0x1F) / 31.0f;
    col[1].a = 1.0f;
#elif defined(_VSDEF_COLOR1_RGB8)
    col[1] = vec4(clamp((color1.rgb / 255.0f), 0.0, 1.0), 1.0);
#elif defined(_VSDEF_COLOR1__RGBX8)
    col[1] = vec4(clamp((color1.abg / 255.0f), 0.0, 1.0), 1.0);
#elif defined(_VSDEF_COLOR1_RGBA4)
    col[1].r = float(int(color1[1]) >> 4) / 15.0f;
    col[1].g = float(int(color1[1]) & 0xF) / 15.0f;
    col[1].b = float(int(color1[0]) >> 4) / 15.0f;
    col[1].a = float(int(color1[0]) & 0xF) / 15.0f;
#elif defined(_VSDEF_COLOR1_RGBA6)
    col[1].r = float(int(color1[0]) >> 2) / 63.0f;
    col[1].g = float(((int(color1[0]) & 0x3) << 4) | (int(color1[1]) >> 4)) / 63.0f;
    col[1].b = float(((int(color1[1]) & 0xF) << 2) | (int(color1[2]) >> 6)) / 63.0f;
    col[1].a = float(int(color1[2]) & 0x3F) / 63.0f;
#elif defined(_VSDEF_COLOR1_RGBA8)
    col[1] = clamp((color1.abgr / 255.0f), 0.0, 1.0);
#else
    col[1] = vec4(1.0, 1.0, 1.0, 1.0);
#endif

    _VSDEF_SET_CHAN0_LIGHT0;
    _VSDEF_SET_CHAN0_LIGHT1;
    _VSDEF_SET_CHAN0_LIGHT2;
    _VSDEF_SET_CHAN0_LIGHT3;
    _VSDEF_SET_CHAN0_LIGHT4;
    _VSDEF_SET_CHAN0_LIGHT5;
    _VSDEF_SET_CHAN0_LIGHT6;
    _VSDEF_SET_CHAN0_LIGHT7;
    
    _VSDEF_SET_CHAN1_LIGHT0;
    _VSDEF_SET_CHAN1_LIGHT1;
    _VSDEF_SET_CHAN1_LIGHT2;
    _VSDEF_SET_CHAN1_LIGHT3;
    _VSDEF_SET_CHAN1_LIGHT4;
    _VSDEF_SET_CHAN1_LIGHT5;
    _VSDEF_SET_CHAN1_LIGHT6;
    _VSDEF_SET_CHAN1_LIGHT7;
    
#ifdef _VSDEF_LIGHTING_ENABLE_0
    vtx_color[0] = mat[0] * clamp(l_amb[0], 0.0f, 1.0f);
#else
    vtx_color[0] = mat[0] * col[0];
#endif
#ifdef _VSDEF_LIGHTING_ENABLE_1
    vtx_color[1] = mat[1] * clamp(l_amb[1], 0.0f, 1.0f);
#else
    vtx_color[1] = mat[1] * col[1];
#endif
    gl_Position = pos;
}
