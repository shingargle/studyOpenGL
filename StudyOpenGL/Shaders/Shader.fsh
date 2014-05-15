//
//  Shader.fsh
//  StudyOpenGL
//
//  Created by sogata on 2014/05/15.
//  Copyright (c) 2014年 RICOH. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
