// gx_vertex.h
// (c) 2005,2009 Gekko Team

#ifndef __gx_vertex_H__
#define __gx_vertex_H__	

////////////////////////////////////////////////////////////////////////////////
// VERTEX PROCESSOR MACROS

// vertex processor send data
#define GX_SEND_COLOR_RGB(r, g, b)		cv->color[0] = r;					\
										cv->color[1] = g;					\
										cv->color[2] = b;					\
										cv->color[3] = 127;
#define GX_SEND_COLOR_RGBA(r, g, b, a)	cv->color[0] = r;					\
										cv->color[1] = g;					\
										cv->color[2] = b;					\
										cv->color[3] = a;
#define GX_SEND_POSITION_XY(x, y)		cv->pos[0] = (x * _vtx->dqf);		\
										cv->pos[1] = (y * _vtx->dqf);
#define GX_SEND_POSITION_XYZ(x, y, z)	cv->pos[0] = (x * _vtx->dqf);		\
										cv->pos[1] = (y * _vtx->dqf);		\
										cv->pos[2] = (z * _vtx->dqf);	
#define GX_SEND_TEXCOORD_S(i, s)		cv->tex[i][0] = (s * _vtx->dqf);
#define GX_SEND_TEXCOORD_ST(i, s, t)	cv->tex[i][0] = (s * _vtx->dqf);	\
										cv->tex[i][1] = (t * _vtx->dqf);

// cp: register reference
#define CP_VCD_LO(idx)					cp.mem[0x50 + (idx)]
#define CP_VCD_HI(idx)					cp.mem[0x60 + (idx)]
#define CP_VAT_A						cp.mem[0x70 + (_vat)]
#define CP_VAT_B						cp.mem[0x80 + (_vat)]
#define CP_VAT_C						cp.mem[0x90 + (_vat)]
#define CP_DATA_POS_ADDR(idx)			(cp.mem[0xa0] + (idx) * cp.mem[0xb0])
#define CP_DATA_NRM_ADDR(idx)			(cp.mem[0xa1] + (idx) * cp.mem[0xb1])
#define CP_DATA_COL0_ADDR(idx)			(cp.mem[0xa2] + (idx) * cp.mem[0xb2])
#define CP_DATA_TEX_ADDR(idx, n)		(cp.mem[0xa4 + (n)] + (idx) *		\
										cp.mem[0xb4 + (n)])			
#define CP_MATIDX_REG_A					cp.mem[0x30]
#define CP_MATIDX_REG_B					cp.mem[0x40]

// midx: matrix indexes
// index for position/normal matrix	
#define MIDX_POS						(CP_MATIDX_REG_A & 0x3f)	
// index for texture matrices 0-3
#define MIDX_TEX03(n)					((CP_MATIDX_REG_A >>				\
										((n * 6) + 6)) & 0x3f)	
// index for texture matrices 4-7
#define MIDX_TEX47(n)					((CP_MATIDX_REG_B >>				\
										(((n - 4) * 6))) & 0x3f)		

// vcd: stores format type	
#define VCD_MIDX						(CP_VCD_LO(0) & 0x1ff)	
// position matrix
#define VCD_PMIDX						(CP_VCD_LO(0) & 1)	
// texture marix
#define VCD_TMIDX(n)					((CP_VCD_LO(0) >> (1 + n)) & 1)	
// position
#define VCD_POS							((CP_VCD_LO(0) >> 9) & 3)		
// normal
#define VCD_NRM							((CP_VCD_LO(0) >> 11) & 3)			
// color 0 (diff)
#define VCD_COL0						((CP_VCD_LO(0) >> 13) & 3)		
// color 1 (spec)
#define VCD_COL1						((CP_VCD_LO(0) >> 15) & 3)		
// texture coordinates	
#define VCD_TEX(n)						((CP_VCD_HI(0) >> (n * 2)) & 3)		
										
// vat: stores format kind				
// position count
#define VAT_POSCNT						(CP_VAT_A & 1)	
// position format
#define VAT_POSFMT						((CP_VAT_A >> 1) & 7)	
// position shift
#define VAT_POSSHFT						((CP_VAT_A >> 4) & 0x1f)	
// diffuse color count
#define VAT_COL0CNT						((CP_VAT_A >> 13) & 1)	
// diffuse color format
#define VAT_COL0FMT						((CP_VAT_A >> 14) & 7)	
// specular color count
#define VAT_COL1CNT						((CP_VAT_A >> 17) & 1)	
// specular color format
#define VAT_COL1FMT						((CP_VAT_A >> 18) & 7)	
// normal count
#define VAT_NRMCNT						((CP_VAT_A >> 9) & 1)	
// normal format
#define VAT_NRMFMT						((CP_VAT_A >> 10) & 7)			
// 1:shift u8/s8/u16/s16, 0:shift u16/s16
#define VAT_BYTEDEQUANT					((CP_VAT_A >> 30) & 1)				
#define VAT_TEX0CNT						((CP_VAT_A >> 21) & 1)				 
#define VAT_TEX0FMT						((CP_VAT_A >> 22) & 7)				 
#define VAT_TEX0SHFT					((CP_VAT_A >> 25) & 0x1f)			
#define VAT_TEX1CNT						((CP_VAT_B >> 0) & 1)				 
#define VAT_TEX1FMT						((CP_VAT_B >> 1) & 7)				 
#define VAT_TEX1SHFT					((CP_VAT_B >> 4) & 0x1f)			
#define VAT_TEX2CNT						((CP_VAT_B >> 9) & 1)				 
#define VAT_TEX2FMT						((CP_VAT_B >> 10) & 7)				 
#define VAT_TEX2SHFT					((CP_VAT_B >> 13) & 0x1f)			
#define VAT_TEX3CNT						((CP_VAT_B >> 18) & 1)				 
#define VAT_TEX3FMT						((CP_VAT_B >> 19) & 7)				 
#define VAT_TEX3SHFT					((CP_VAT_B >> 22) & 0x1f)			
#define VAT_TEX4CNT						((CP_VAT_B >> 27) & 1)				 
#define VAT_TEX4FMT						((CP_VAT_B >> 28) & 7)				 
#define VAT_TEX4SHFT					(CP_VAT_C & 0x1f)					
#define VAT_TEX5CNT						((CP_VAT_C >> 5) & 1)				 
#define VAT_TEX5FMT						((CP_VAT_C >> 6) & 7)				 
#define VAT_TEX5SHFT					((CP_VAT_C >> 9) & 0x1f)			
#define VAT_TEX6CNT						((CP_VAT_C >> 14) & 1)				 
#define VAT_TEX6FMT						((CP_VAT_C >> 15) & 7)				 
#define VAT_TEX6SHFT					((CP_VAT_C >> 18) & 0x1f)			
#define VAT_TEX7CNT						((CP_VAT_C >> 23) & 1)				 
#define VAT_TEX7FMT						((CP_VAT_C >> 24) & 7)				 
#define VAT_TEX7SHFT					((CP_VAT_C >> 27) & 0x1f)			

// format decoding
#define VTX_FORMAT(vtx)					((vtx.cnt << 3) | vtx.fmt)
#define VTX_FORMAT_VCD(vtx)				((VTX_FORMAT(vtx) << 2) | vtx.vcd)
//#define VTX_FORMAT_VCD(vtx)				((VTX_FORMAT(vtx) << 1) | (vtx.vcd>>1))

// texture coordinate format decoding
#define TEXLOOP(i)											\
{															\
		switch(tex[i].vcd)									\
		{													\
		case 0:												\
			break;											\
		case 1:												\
			tex[i].position = offset;						\
			offset+=tex[i].vtx_format;						\
			((gxtextable)tex[i].vtx_format_vcd)(_gxlist, &tex[i], i);	\
			if(bp.tevorder[i >> 1].get_enable(i))				\
				gx_transform::tex_gen(i);						\
			break;											\
		case 2:												\
			tex[i].index = _gxlist->get8(offset++);			\
			((gxtextable)tex[i].vtx_format_vcd)(_gxlist, &tex[i], i);	\
			if(bp.tevorder[i >> 1].get_enable(i))				\
				gx_transform::tex_gen(i);						\
			break;											\
		case 3:												\
			tex[i].index = _gxlist->get16(offset);			\
			offset+=2;										\
			((gxtextable)tex[i].vtx_format_vcd)(_gxlist, &tex[i], i);	\
			if(bp.tevorder[i >> 1].get_enable(i))				\
				gx_transform::tex_gen(i);						\
			break;											\
		}													\
		if(bp.tevorder[i >> 1].get_enable(i))				\
		{													\
			glMultiTexCoord2fv((GL_TEXTURE0 + i), cv->ttex);	\
		}													\
}

// texture coordinate format decoding (size)
#define TEXSIZELOOP(i, CNT, FMT)							\
	switch(VCD_TEX(i))										\
	{														\
	case 1:													\
		size+=gx_texcoord_size[((CNT << 3) | FMT)];			\
		break;												\
	case 2: size+=1; break;									\
	case 3: size+=2; break;									\
	}

////////////////////////////////////////////////////////////////////////////////
// VERTEX PROCESSOR STRUCTURES

// gx vertex 
struct Vertex
{
	f32 pos[4];
	f32 tpos[4];
	f32 tex[8][2];
	f32 tex_temp[2];
	f32 ttex[4];
	f32 nrm[4];
	s8 color[4], col0[4], col1[3];
	u8 is3d;
};

// vertex base data structure
struct gx_vertex_data
{
	u8		cnt;				// count
	u8		fmt;				// format
	u8		vcd;				// type
	u8		num;				// number (textures)
	u16		index;				// offset (indexed, 8 or 18bit)
	u32		position;			// offset (direct)
	f32		dqf;				// scale factor
	void *	vtx_format_vcd;		// ptr to func[(vtx_format << 2) | vcd](...);
	u32		vtx_format;			// (cnt << 3) | fmt
};

typedef void (*gxtable)(cgxlist* _gxlist, gx_vertex_data *_vtx);	
typedef void (*gxtextable)(cgxlist* _gxlist, gx_vertex_data *_vtx, int i);	

extern Vertex vtxarray[1];
extern Vertex *cv;

////////////////////////////////////////////////////////////////////////////////
// VERTEX PROCESSOR SIZE ARRAYS

// size (in bytes) of position format
static const u8 gx_poscoord_size[16] = 
{
	2,	2,	4,	4,	8,	0,	0,	0,	// two pos xy
	3,	3,	6,	6,	12,	0,	0,	0	// three pos xyz
};

// size (in bytes) of color format
static const u8 gx_color_size[16] = 
{
	2,	3,	4,	0,	0,	0,	0,	0,	// col rgb
	0,	0,	0,	2,	3,	4,	0,	0	// col rgba
};

// size (in bytes) of normal format
static const u8 gx_normal_size[16] = 
{
	0,	3,	0,	6,	12,	0,	0,	0,	// three nrms
	0,	9,	0,	18,	36,	0,	0,	0	// nine nrms
};

// size (in bytes) of texture format
static const u8 gx_texcoord_size[16] = 
{
	1,	1,	2,	2,	4,	0,	0,	0,	// one coord s
	2,	2,	4,	4,	8,	0,	0,	0	// two coords st
};

////////////////////////////////////////////////////////////////////////////////
// VERTEX PROCESSOR NAMESPACE

namespace gx_vertex
{
	// vertex processor variables	
	extern u8 pm_index;					// position matrix index
	extern u8 tm_index[8];				// texture matrix indexes
	extern f32 dqfactor;				// dequantization factor 
										// (position of decimal)
	
	extern char outbuff[64];			// debug output
	extern char outbuff2[64];			// debug output2
	extern char	outbuff3[64];			// debug output3
	extern char	outbuff4[64];			// debug output4

	struct VertexListStruct
	{
		int	GLVertexList;
		u32	CRCHash;
	};

	#define VertexListSize	(1024*1024*2)
	extern VertexListStruct	VertexList[VertexListSize];
	extern u32 vcd_midx_result;
	extern u32 vcd_pmidx_result;

	// primitive drawing
	int get_size(u8 _vat);
	inline void get_vertex(u8 _vat);
	void send_vertex(cgxlist* _gxlist, u8 _vat);
	void send_vertex_midx(cgxlist* _gxlist, u8 _vat);
	void send_vertex_pmidx(cgxlist* _gxlist, u8 _vat);
	void draw_primitive(cgxlist* _gxlist, GLenum _type, int _count, u8 _vat);

	// namespace
	void initialize(void);
	void destroy(void);
};

////////////////////////////////////////////////////////////////////////////////
// EOF

#endif