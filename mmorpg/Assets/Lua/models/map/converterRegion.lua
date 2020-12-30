 --[[--
-- 计算四边形映射
-- @Author:HuangJunShan
-- @DateTime:2017-04-22 11:23:02
--]]

local ConverterRegion = {}

local srcX = {}
local srcY = {}
local srcMat = {}

local dstX = {}
local dstY = {}
local dstMat = {}

local warpMat = {}

function ConverterRegion:setIdentity(scr0,scr1,scr2,scr3,des0,des1,des2,des3)
    self:setSource(scr0.x,scr0.y,scr1.x,scr1.y,scr2.x,scr2.y,scr3.x,scr3.y)
    self:setDestination(des0.x,des0.y,des1.x,des1.y,des2.x,des2.y,des3.x,des3.y)
    self:computeWarp()
    return warpMat
end

function ConverterRegion:setSource(x0,y0,x1,y1,x2,y2,x3,y3)
    srcX[0] = x0
    srcY[0] = y0
    srcX[1] = x1
    srcY[1] = y1
    srcX[2] = x2
    srcY[2] = y2
    srcX[3] = x3
    srcY[3] = y3
end
 
function ConverterRegion:setDestination(x0,y0,x1,y1,x2,y2,x3,y3)
    dstX[0] = x0
    dstY[0] = y0
    dstX[1] = x1
    dstY[1] = y1
    dstX[2] = x2
    dstY[2] = y2
    dstX[3] = x3
    dstY[3] = y3
end

function ConverterRegion:multMats(srcMat,dstMat,resMat)
    for r=0,3 do
        local ri = r * 4;
        for c=0,3 do
            resMat[ri + c] = (srcMat[ri] * dstMat[c] +
            srcMat[ri + 1] * dstMat[c +  4] +
            srcMat[ri + 2] * dstMat[c +  8] +
            srcMat[ri + 3] * dstMat[c + 12])
        end
    end
end
 
function ConverterRegion:computeQuadToSquare(x0,y0,x1,y1,x2,y2,x3,y3,mat)
    self:computeSquareToQuad(x0,y0,x1,y1,x2,y2,x3,y3,mat);
     
    local a = mat[ 0]
    local d = mat[ 1]
    local g = mat[ 3]
    local b = mat[ 4]
    local e = mat[ 5]
    local h = mat[ 7]
    local c = mat[12]
    local f = mat[13]
     
    local A =     e - f * h
    local B = c * h - b
    local C = b * f - c * e
    local D = f * g - d
    local E =     a - c * g
    local F = c * d - a * f
    local G = d * h - e * g
    local H = b * g - a * h
    local I = a * e - b * d

    local idet = 1 / (a * A + b * D + c * G)
     
    mat[ 0] = A * idet
	mat[ 1] = D * idet
	mat[ 2] = 0
	mat[ 3] = G * idet
	
    mat[ 4] = B * idet
	mat[ 5] = E * idet
	mat[ 6] = 0
	mat[ 7] = H * idet
	
    mat[ 8] = 0       
	mat[ 9] = 0       
	mat[10] = 1
	mat[11] = 0       
	
    mat[12] = C * idet
	mat[13] = F * idet
	mat[14] = 0
	mat[15] = I * idet
end
 
function ConverterRegion:computeSquareToQuad(x0,y0,x1,y1,x2,y2,x3,y3,mat)
    local dx1 = x1 - x2
    local dy1 = y1 - y2
    local dx2 = x3 - x2
    local dy2 = y3 - y2
    local sx = x0 - x1 + x2 - x3
    local sy = y0 - y1 + y2 - y3
    local g = (sx * dy2 - dx2 * sy) / (dx1 * dy2 - dx2 * dy1)
    local h = (dx1 * sy - sx * dy1) / (dx1 * dy2 - dx2 * dy1)
    local a = x1 - x0 + g * x1
    local b = x3 - x0 + h * x3
    local c = x0
    local d = y1 - y0 + g * y1
    local e = y3 - y0 + h * y3
    local f = y0
     
    mat[ 0] = a
	mat[ 1] = d
	mat[ 2] = 0
	mat[ 3] = g
	
    mat[ 4] = b
	mat[ 5] = e
	mat[ 6] = 0
	mat[ 7] = h
	
    mat[ 8] = 0
	mat[ 9] = 0
	mat[10] = 1
	mat[11] = 0
	
    mat[12] = c
	mat[13] = f
	mat[14] = 0
	mat[15] = 1
end
 
function ConverterRegion:computeWarp()
    self:computeQuadToSquare(srcX[0],srcY[0],
        srcX[1],srcY[1],
        srcX[2],srcY[2],
        srcX[3],srcY[3],
        srcMat)
    self:computeSquareToQuad(dstX[0], dstY[0],
        dstX[1], dstY[1],
        dstX[2], dstY[2],
        dstX[3], dstY[3],
        dstMat)
    self:multMats(srcMat, dstMat, warpMat)
end
 
function ConverterRegion:warp(mat,srcX,srcY)
    local z = 0
    local result = {}
    result[0] = srcX * mat[0] + srcY*mat[4] + z*mat[8] + 1*mat[12]
    result[1] = srcX * mat[1] + srcY*mat[5] + z*mat[9] + 1*mat[13]
    result[2] = srcX * mat[2] + srcY*mat[6] + z*mat[10] + 1*mat[14]
    result[3] = srcX * mat[3] + srcY*mat[7] + z*mat[11] + 1*mat[15]
    local dstX = result[0]/result[3]
    local dstY = result[1]/result[3]
    return dstX,dstY
end

return ConverterRegion