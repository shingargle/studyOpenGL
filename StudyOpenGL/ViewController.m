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
    
    static	float	sVerts[] =
    {	 1,	 1,	 1,
        1,	-1,	-1,
        -1,	 1,	-1,
        
        1,	-1,	-1,
        -1,	 1,	-1,
        -1,	-1,	 1,
        
        -1,	 1,	-1,
        -1,	-1,	 1,
        1,	 1,	 1,
        
        -1,	-1,	 1,
        1,	 1,	 1,
        1,	-1,	-1
    };
    glBufferData(GL_ARRAY_BUFFER, sizeof(sVerts), sVerts, GL_STATIC_DRAW);
}

- (void) viewWillDisappear:(BOOL)animated
{
    // 使い終わったら片付ける
    [super viewWillDisappear:animated];
    mEffect = nil;
    ((GLKView*)self.view).context = nil;
    // -----------
    glDeleteBuffers(1, &mBuffer);
}

- (void) update
{
    mTime += self.timeSinceLastUpdate;
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
    
    glEnableVertexAttribArray( GLKVertexAttribPosition );
    glDrawArrays( GL_TRIANGLES, 0, 12 );
    glDisableVertexAttribArray( GLKVertexAttribPosition );
}

@end