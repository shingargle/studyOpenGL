//
//  ViewController.m
//  StudyOpenGL
//
//  Created by sogata on 2014/05/15.
//  Copyright (c) 2014年 RICOH. All rights reserved.
//

#import "ViewController.h"
@interface ViewController()
{
    float mTime;
    GLKBaseEffect* mEffect;
    GLuint mBuffer;
    GLuint cBuffer;
}
@end

@implementation ViewController
- (void) viewDidAppear:(BOOL)animated
{
    // GLKViewController を使う準備
    [super viewDidAppear:animated];
    ((GLKView *)self.view).context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //OpenGL ES 2.0になる
    EAGLContext.currentContext = ((GLKView*)self.view).context;
    mEffect = [[GLKBaseEffect alloc] init];
    // ------------
    
    glGenBuffers(1, &mBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, mBuffer);
    static	float	sVerts[] ={/*
     -1, -1, -1,//0
     1, -1, -1,//1
     1, 1, -1,//2
     -1, 1, -1,//3
     -1, -1, 1,//4
     1, -1, 1,//5
     1, 1, 1,//6
     -1, 1, 1,//7
                                */
     -1, -1, -1,//0
     1, -1, -1,//1
     -1, 1, -1,//3
     1, 1, -1,//2
        
     1, 1, -1,//2
     -1, 1, -1,//3
     1, 1, 1,//6
     -1, 1, 1,//7
        
     -1, 1, 1,//7
     -1, -1, 1,//4
     1, 1, 1,//6
     1, -1, 1,//5
        
     1, -1, 1,//5
     -1, -1, 1,//4
     1, -1, -1,//1
     -1, -1, -1,//0
        
     -1, -1, -1,//0
     -1, -1, 1,//4
     -1, 1, -1,//3
     -1, 1, 1,//7
        
     -1, 1, 1,//7
     -1, -1, 1,//4
     1, 1, 1,//6
     1, -1, 1,//5
        
     1, -1, 1,//5
     1, 1, 1,//6
     1, -1, -1,//1
     1, 1, -1,//2
        
        
        
    };
    
    /*    {	-1,	-1,	-1, //p1
       -1,	-1,	1, //p2
        -1,	1,	-1,//p3
        -1,	1,	1, //p4
        
        -1,	-1,	-1, //p1
        -1,	1,	-1, //p3
        1,	-1,	-1, //p5
        1,	1,	-1, //p7
        
        -1,	-1,	-1, //p1
        1,	-1,	-1, //p5
       -1,	-1,	1, //p2
        1,	-1,	1, //p6
        
       1,	1,	1, //p8
        1,	-1,	1, //p6
        1,	1,	-1, //p7
        1,	-1,	-1, //p5
        
       1,	1,	1, //p8
        -1,	1,	1, //p4
        1,	-1,	1, //p6
       -1,	-1,	1, //p2
        
       1,	1,	1, //p8
        1,	1,	-1, //p7
        -1,	1,	1, //p4
        -1,	1,	-1,//p3
    };*/
    glBufferData(GL_ARRAY_BUFFER, sizeof(sVerts), sVerts, GL_STATIC_DRAW);
    
    static	GLKVector4	sColors[] =
    {
        {	 1,	 0,	 0,	 1	}
		,	{	 1,	 0,	 0,	 1	}
		,	{	 1,	 0,	 0,	 1	}
		,	{	 1,	 0,	 0,	 1	}
        
		,	{	 0,	 0,	 1,	 1	}
		,	{	 0,	 0,	 1,	 1	}
		,	{	 0,	 0,	 1,	 1	}
		,	{	 0,	 0,	 1,	 1	}
        
		,	{	 0,	 1,	 0,	 1	}
		,	{	 0,	 1,	 0,	 1	}
		,	{	 0,	 1,	 0,	 1	}
		,	{	 0,	 1,	 0,	 1	}
        
		,	{	 0,	 1,	 1,	 1	}
		,	{	 0,	 1,	 1,	 1	}
		,	{	 0,	 1,	 1,	 1	}
		,	{	 0,	 1,	 1,	 1	}
        
		,	{	 1,	 1,	 0,	 1	}
		,	{	 1,	 1,	 0,	 1	}
		,	{	 1,	 1,	 0,	 1	}
		,	{	 1,	 1,	 0,	 1	}
        
       ,    {	 1,	 0,	 0,	 0	}
		,	{	 1,	 0,	 0,	 0	}
		,	{	 1,	 0,	 0,	 0	}
		,	{	 1,	 0,	 0,	 0	}
        
       ,    {	 1,	 1,	 1,	 1	}
		,	{	 1,	 1,	 1,	 1	}
		,	{	 1,	 1,	 1,	 1	}
		,	{	 1,	 1,	 1,	 1	}
    };
    
    glGenBuffers(1, &cBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, cBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sColors), sColors, GL_STATIC_DRAW);
    
    // 色々考えろ。と伝えている箇所
    ((GLKView*)self.view).drawableDepthFormat = GLKViewDrawableDepthFormat24;
	glEnable( GL_DEPTH_TEST );
}

- (void) viewWillDisappear:(BOOL)animated
{
    // 使い終わったら片付ける
    [super viewWillDisappear:animated];
    mEffect = nil;
    ((GLKView*)self.view).context = nil;
    // -----------
    glDeleteBuffers(1, &mBuffer);
    glDeleteBuffers(1, &cBuffer);
    
}

- (void) update
{
    mTime = mTime + self.timeSinceLastUpdate * 2;
}

//GLKBaseEffect を使って３角形を描画する。(3次元にお試し改良)
// http://paraiso.moo.jp/wp/?p=61
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    mEffect.transform.modelviewMatrix = GLKMatrix4Rotate(	GLKMatrix4MakeScale( .5, .5, .5 )
                                                                ,	mTime
                                                                ,	1
                                                                ,	1
                                                                ,	1
                                                                );
    mEffect.transform.projectionMatrix = GLKMatrix4MakeScale( 1, view.bounds.size.width / view.bounds.size.height, 1 );
    [mEffect prepareToDraw];

    [self draw];
}
- (void) draw
{
    glBindBuffer( GL_ARRAY_BUFFER, mBuffer );
    glVertexAttribPointer( GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), 0 );
    glBindBuffer( GL_ARRAY_BUFFER, cBuffer );
    glVertexAttribPointer( GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), 0 );
    
    glEnableVertexAttribArray( GLKVertexAttribPosition );
    glEnableVertexAttribArray( GLKVertexAttribColor );
    glDrawArrays( GL_TRIANGLE_STRIP, 0, 28 );
    glDisableVertexAttribArray( GLKVertexAttribPosition );
    glDisableVertexAttribArray( GLKVertexAttribColor );
}

@end