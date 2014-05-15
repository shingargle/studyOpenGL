//
//  ViewController.m
//  StudyOpenGL
//
//  Created by sogata on 2014/05/15.
//  Copyright (c) 2014年 RICOH. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
- (void) viewDidAppear:(BOOL)animated
{
    // GLKViewController を使う準備
    [super viewDidAppear:animated];
    ((GLKView *)self.view).context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //OpenGL ES 2.0になる
    EAGLContext.currentContext = ((GLKView*)self.view).context;
    mEffect = [[GLKBaseEffect alloc] init];
    // ------------
}

- (void) viewWillDisappear:(BOOL)animated
{
    // 使い終わったら片付ける
    [super viewWillDisappear:animated];
    mEffect = nil;
    ((GLKView*)self.view).context = nil;
    // -----------
}

- (void) update
{
    mTime += self.timeSinceLastUpdate;
}

//GLKBaseEffect を使って３角形を描画する。(3次元にお試し改良)
// http://paraiso.moo.jp/wp/?p=22
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    mEffect.transform.modelviewMatrix = GLKMatrix4MakeYRotation(mTime);
    // 描画に先立って prepareToDraw で準備
    // [[[GLKBaseEffect alloc] init] prepareToDraw];
    // 回転させるために以下のように変更
//    GLKBaseEffect * wEffect = [[GLKBaseEffect alloc] init];
//    wEffect.transform.modelviewMatrix = GLKMatrix4MakeZRotation(M_PI/4);
//    [wEffect prepareToDraw];
    // 更に変更し時間で回るように
    [mEffect prepareToDraw];

    //頂点データを有効
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    static float sData[] =
    {
        -0.4, -0.8, 0,
        +0.8, -0.8, 0,
        0,  1, 0
    };
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 8, sData);
    /*
     引数１：        種類：頂点データ
     引数２：      次元数：２
     引数３：          型：float
     引数４：ノーマライズ：しない（引数が整数で与えられた時のコンバージョンを方法）
     引数５：  ストライド：８
     引数６：    実データ：sData
     */
    glDrawArrays(GL_TRIANGLES, 0, 3);
}


@end