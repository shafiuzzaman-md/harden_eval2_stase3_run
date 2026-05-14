; ModuleID = 'out/eval2_linux/path_a/evt_notifier_line162/harness.bc'
source_filename = "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_evt_notifier_line162.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.file = type opaque

@message_size = internal global i16 0, align 2, !dbg !0
@message = internal global i8* null, align 8, !dbg !20
@.str = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"off\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !35 {
  %1 = alloca i32, align 4
  %2 = alloca [256 x i8], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [256 x i8]* %2, metadata !41, metadata !DIExpression()), !dbg !45
  call void @llvm.dbg.declare(metadata i64* %3, metadata !46, metadata !DIExpression()), !dbg !47
  call void @llvm.dbg.declare(metadata i64* %4, metadata !48, metadata !DIExpression()), !dbg !49
  store i16 100, i16* @message_size, align 2, !dbg !50
  %5 = load i16, i16* @message_size, align 2, !dbg !51
  %6 = sext i16 %5 to i64, !dbg !52
  %7 = call noalias i8* @malloc(i64 noundef %6) #7, !dbg !53
  store i8* %7, i8** @message, align 8, !dbg !54
  %8 = load i8*, i8** @message, align 8, !dbg !55
  %9 = icmp ne i8* %8, null, !dbg !55
  br i1 %9, label %11, label %10, !dbg !57

10:                                               ; preds = %0
  store i32 1, i32* %1, align 4, !dbg !58
  br label %40, !dbg !58

11:                                               ; preds = %0
  %12 = load i8*, i8** @message, align 8, !dbg !59
  %13 = load i16, i16* @message_size, align 2, !dbg !60
  %14 = sext i16 %13 to i64, !dbg !61
  %15 = call i8* @memset(i8* %12, i32 65, i64 %14), !dbg !62
  %16 = bitcast i64* %3 to i8*, !dbg !63
  call void @klee_make_symbolic(i8* noundef %16, i64 noundef 8, i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0)), !dbg !64
  %17 = bitcast i64* %4 to i8*, !dbg !65
  call void @klee_make_symbolic(i8* noundef %17, i64 noundef 8, i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0)), !dbg !66
  %18 = load i64, i64* %3, align 8, !dbg !67
  %19 = icmp ugt i64 %18, 0, !dbg !68
  %20 = zext i1 %19 to i32, !dbg !68
  %21 = sext i32 %20 to i64, !dbg !67
  call void @klee_assume(i64 noundef %21), !dbg !69
  %22 = load i64, i64* %3, align 8, !dbg !70
  %23 = icmp ule i64 %22, 256, !dbg !71
  %24 = zext i1 %23 to i32, !dbg !71
  %25 = sext i32 %24 to i64, !dbg !70
  call void @klee_assume(i64 noundef %25), !dbg !72
  %26 = load i64, i64* %4, align 8, !dbg !73
  %27 = load i16, i16* @message_size, align 2, !dbg !74
  %28 = sext i16 %27 to i64, !dbg !75
  %29 = icmp sgt i64 %26, %28, !dbg !76
  %30 = zext i1 %29 to i32, !dbg !76
  %31 = sext i32 %30 to i64, !dbg !73
  call void @klee_assume(i64 noundef %31), !dbg !77
  %32 = load i64, i64* %4, align 8, !dbg !78
  %33 = icmp slt i64 %32, 65536, !dbg !79
  %34 = zext i1 %33 to i32, !dbg !79
  %35 = sext i32 %34 to i64, !dbg !78
  call void @klee_assume(i64 noundef %35), !dbg !80
  %36 = getelementptr inbounds [256 x i8], [256 x i8]* %2, i64 0, i64 0, !dbg !81
  %37 = load i64, i64* %3, align 8, !dbg !82
  %38 = call i64 @dr_w_dev_read(%struct.file* noundef null, i8* noundef %36, i64 noundef %37, i64* noundef %4), !dbg !83
  %39 = load i8*, i8** @message, align 8, !dbg !84
  call void @free(i8* noundef %39) #7, !dbg !85
  store i32 0, i32* %1, align 4, !dbg !86
  br label %40, !dbg !86

40:                                               ; preds = %11, %10
  %41 = load i32, i32* %1, align 4, !dbg !87
  ret i32 %41, !dbg !87
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

declare void @klee_make_symbolic(i8* noundef, i64 noundef, i8* noundef) #4

declare void @klee_assume(i64 noundef) #4

; Function Attrs: noinline nounwind optnone uwtable
define internal i64 @dr_w_dev_read(%struct.file* noundef %0, i8* noundef %1, i64 noundef %2, i64* noundef %3) #0 !dbg !88 {
  %5 = alloca i64, align 8
  %6 = alloca %struct.file*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64*, align 8
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store %struct.file* %0, %struct.file** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.file** %6, metadata !95, metadata !DIExpression()), !dbg !96
  store i8* %1, i8** %7, align 8
  call void @llvm.dbg.declare(metadata i8** %7, metadata !97, metadata !DIExpression()), !dbg !98
  store i64 %2, i64* %8, align 8
  call void @llvm.dbg.declare(metadata i64* %8, metadata !99, metadata !DIExpression()), !dbg !100
  store i64* %3, i64** %9, align 8
  call void @llvm.dbg.declare(metadata i64** %9, metadata !101, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.declare(metadata i32* %10, metadata !103, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.declare(metadata i32* %11, metadata !105, metadata !DIExpression()), !dbg !106
  %12 = load i64, i64* %8, align 8, !dbg !107
  %13 = load i16, i16* @message_size, align 2, !dbg !107
  %14 = sext i16 %13 to i64, !dbg !107
  %15 = load i64*, i64** %9, align 8, !dbg !107
  %16 = load i64, i64* %15, align 8, !dbg !107
  %17 = sub nsw i64 %14, %16, !dbg !107
  %18 = icmp ult i64 %12, %17, !dbg !107
  br i1 %18, label %19, label %21, !dbg !107

19:                                               ; preds = %4
  %20 = load i64, i64* %8, align 8, !dbg !107
  br label %27, !dbg !107

21:                                               ; preds = %4
  %22 = load i16, i16* @message_size, align 2, !dbg !107
  %23 = sext i16 %22 to i64, !dbg !107
  %24 = load i64*, i64** %9, align 8, !dbg !107
  %25 = load i64, i64* %24, align 8, !dbg !107
  %26 = sub nsw i64 %23, %25, !dbg !107
  br label %27, !dbg !107

27:                                               ; preds = %21, %19
  %28 = phi i64 [ %20, %19 ], [ %26, %21 ], !dbg !107
  %29 = trunc i64 %28 to i32, !dbg !107
  store i32 %29, i32* %11, align 4, !dbg !106
  %30 = load i32, i32* %11, align 4, !dbg !108
  %31 = icmp sle i32 %30, 0, !dbg !110
  br i1 %31, label %32, label %33, !dbg !111

32:                                               ; preds = %27
  store i64 0, i64* %5, align 8, !dbg !112
  br label %53, !dbg !112

33:                                               ; preds = %27
  %34 = load i8*, i8** %7, align 8, !dbg !114
  %35 = load i8*, i8** @message, align 8, !dbg !114
  %36 = load i64*, i64** %9, align 8, !dbg !114
  %37 = load i64, i64* %36, align 8, !dbg !114
  %38 = getelementptr inbounds i8, i8* %35, i64 %37, !dbg !114
  %39 = load i32, i32* %11, align 4, !dbg !114
  %40 = sext i32 %39 to i64, !dbg !114
  %41 = call i8* @memcpy(i8* %34, i8* %38, i64 %40), !dbg !114
  store i32 0, i32* %10, align 4, !dbg !116
  %42 = load i32, i32* %10, align 4, !dbg !117
  %43 = icmp eq i32 %42, 0, !dbg !119
  br i1 %43, label %44, label %52, !dbg !120

44:                                               ; preds = %33
  %45 = load i32, i32* %11, align 4, !dbg !121
  %46 = sext i32 %45 to i64, !dbg !121
  %47 = load i64*, i64** %9, align 8, !dbg !123
  %48 = load i64, i64* %47, align 8, !dbg !124
  %49 = add nsw i64 %48, %46, !dbg !124
  store i64 %49, i64* %47, align 8, !dbg !124
  %50 = load i32, i32* %11, align 4, !dbg !125
  %51 = sext i32 %50 to i64, !dbg !125
  store i64 %51, i64* %5, align 8, !dbg !126
  br label %53, !dbg !126

52:                                               ; preds = %33
  store i64 -1, i64* %5, align 8, !dbg !127
  br label %53, !dbg !127

53:                                               ; preds = %52, %44, %32
  %54 = load i64, i64* %5, align 8, !dbg !129
  ret i64 %54, !dbg !129
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #5

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @memcpy(i8* noundef %0, i8* noundef %1, i64 noundef %2) #6 !dbg !130 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !137, metadata !DIExpression()), !dbg !138
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !139, metadata !DIExpression()), !dbg !140
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !141, metadata !DIExpression()), !dbg !142
  call void @llvm.dbg.declare(metadata i8** %7, metadata !143, metadata !DIExpression()), !dbg !144
  %9 = load i8*, i8** %4, align 8, !dbg !145
  store i8* %9, i8** %7, align 8, !dbg !144
  call void @llvm.dbg.declare(metadata i8** %8, metadata !146, metadata !DIExpression()), !dbg !149
  %10 = load i8*, i8** %5, align 8, !dbg !150
  store i8* %10, i8** %8, align 8, !dbg !149
  br label %11, !dbg !151

11:                                               ; preds = %15, %3
  %12 = load i64, i64* %6, align 8, !dbg !152
  %13 = add i64 %12, -1, !dbg !152
  store i64 %13, i64* %6, align 8, !dbg !152
  %14 = icmp ugt i64 %12, 0, !dbg !153
  br i1 %14, label %15, label %21, !dbg !151

15:                                               ; preds = %11
  %16 = load i8*, i8** %8, align 8, !dbg !154
  %17 = getelementptr inbounds i8, i8* %16, i32 1, !dbg !154
  store i8* %17, i8** %8, align 8, !dbg !154
  %18 = load i8, i8* %16, align 1, !dbg !155
  %19 = load i8*, i8** %7, align 8, !dbg !156
  %20 = getelementptr inbounds i8, i8* %19, i32 1, !dbg !156
  store i8* %20, i8** %7, align 8, !dbg !156
  store i8 %18, i8* %19, align 1, !dbg !157
  br label %11, !dbg !151, !llvm.loop !158

21:                                               ; preds = %11
  %22 = load i8*, i8** %4, align 8, !dbg !160
  ret i8* %22, !dbg !161
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @memset(i8* noundef %0, i32 noundef %1, i64 noundef %2) #6 !dbg !162 {
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !166, metadata !DIExpression()), !dbg !167
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !168, metadata !DIExpression()), !dbg !169
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !170, metadata !DIExpression()), !dbg !171
  call void @llvm.dbg.declare(metadata i8** %7, metadata !172, metadata !DIExpression()), !dbg !173
  %8 = load i8*, i8** %4, align 8, !dbg !174
  store i8* %8, i8** %7, align 8, !dbg !173
  br label %9, !dbg !175

9:                                                ; preds = %13, %3
  %10 = load i64, i64* %6, align 8, !dbg !176
  %11 = add i64 %10, -1, !dbg !176
  store i64 %11, i64* %6, align 8, !dbg !176
  %12 = icmp ugt i64 %10, 0, !dbg !177
  br i1 %12, label %13, label %18, !dbg !175

13:                                               ; preds = %9
  %14 = load i32, i32* %5, align 4, !dbg !178
  %15 = trunc i32 %14 to i8, !dbg !178
  %16 = load i8*, i8** %7, align 8, !dbg !179
  %17 = getelementptr inbounds i8, i8* %16, i32 1, !dbg !179
  store i8* %17, i8** %7, align 8, !dbg !179
  store i8 %15, i8* %16, align 1, !dbg !180
  br label %9, !dbg !175, !llvm.loop !181

18:                                               ; preds = %9
  %19 = load i8*, i8** %4, align 8, !dbg !182
  ret i8* %19, !dbg !183
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { argmemonly nofree nounwind willreturn writeonly }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { argmemonly nofree nounwind willreturn }
attributes #6 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nounwind }

!llvm.dbg.cu = !{!2, !23, !25}
!llvm.module.flags = !{!27, !28, !29, !30, !31, !32, !33}
!llvm.ident = !{!34, !34, !34}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "message_size", scope: !2, file: !18, line: 69, type: !22, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_evt_notifier_line162.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "e32e7ae719a87e491eef43a000b3a3a1")
!4 = !{!5, !7, !10, !16}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !8, line: 46, baseType: !9)
!8 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!9 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "loff_t", file: !11, line: 42, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/sys/types.h", directory: "", checksumkind: CSK_MD5, checksum: "7fb02a803b0c9b11cb5276b77d21e9d8")
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "__loff_t", file: !13, line: 203, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "", checksumkind: CSK_MD5, checksum: "e1865d9fe29fe1b5ced550b7ba458f9e")
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !13, line: 153, baseType: !15)
!15 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DICompositeType(tag: DW_TAG_structure_type, name: "file", file: !18, line: 64, flags: DIFlagFwdDecl)
!18 = !DIFile(filename: "out/eval2_linux/harnesses/harness_evt_notifier_line162.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "e32e7ae719a87e491eef43a000b3a3a1")
!19 = !{!0, !20}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "message", scope: !2, file: !18, line: 68, type: !5, isLocal: true, isDefinition: true)
!22 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!23 = distinct !DICompileUnit(language: DW_LANG_C99, file: !24, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!24 = !DIFile(filename: "/home/shafi/tools/klee/runtime/Freestanding/memcpy.c", directory: "/home/shafi/tools/klee/build/runtime/Freestanding", checksumkind: CSK_MD5, checksum: "c636d77d986b2156da8c1ff12af1c5cd")
!25 = distinct !DICompileUnit(language: DW_LANG_C99, file: !26, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!26 = !DIFile(filename: "/home/shafi/tools/klee/runtime/Freestanding/memset.c", directory: "/home/shafi/tools/klee/build/runtime/Freestanding", checksumkind: CSK_MD5, checksum: "f66ef9ef9131ab198e93a41b1a9ae1fc")
!27 = !{i32 7, !"Dwarf Version", i32 5}
!28 = !{i32 2, !"Debug Info Version", i32 3}
!29 = !{i32 1, !"wchar_size", i32 4}
!30 = !{i32 7, !"PIC Level", i32 2}
!31 = !{i32 7, !"PIE Level", i32 2}
!32 = !{i32 7, !"uwtable", i32 1}
!33 = !{i32 7, !"frame-pointer", i32 2}
!34 = !{!"Ubuntu clang version 14.0.6"}
!35 = distinct !DISubprogram(name: "main", scope: !36, file: !36, line: 172, type: !37, scopeLine: 173, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !40)
!36 = !DIFile(filename: "evt_notifier.c", directory: "/home/shafi/harden/eval3_demo/stase3")
!37 = !DISubroutineType(types: !38)
!38 = !{!39}
!39 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!40 = !{}
!41 = !DILocalVariable(name: "user_buf", scope: !35, file: !36, line: 174, type: !42)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 2048, elements: !43)
!43 = !{!44}
!44 = !DISubrange(count: 256)
!45 = !DILocation(line: 174, column: 13, scope: !35)
!46 = !DILocalVariable(name: "len", scope: !35, file: !36, line: 175, type: !7)
!47 = !DILocation(line: 175, column: 13, scope: !35)
!48 = !DILocalVariable(name: "off", scope: !35, file: !36, line: 176, type: !10)
!49 = !DILocation(line: 176, column: 13, scope: !35)
!50 = !DILocation(line: 180, column: 18, scope: !35)
!51 = !DILocation(line: 181, column: 38, scope: !35)
!52 = !DILocation(line: 181, column: 30, scope: !35)
!53 = !DILocation(line: 181, column: 23, scope: !35)
!54 = !DILocation(line: 181, column: 13, scope: !35)
!55 = !DILocation(line: 182, column: 10, scope: !56)
!56 = distinct !DILexicalBlock(scope: !35, file: !36, line: 182, column: 9)
!57 = !DILocation(line: 182, column: 9, scope: !35)
!58 = !DILocation(line: 182, column: 19, scope: !56)
!59 = !DILocation(line: 183, column: 12, scope: !35)
!60 = !DILocation(line: 183, column: 34, scope: !35)
!61 = !DILocation(line: 183, column: 26, scope: !35)
!62 = !DILocation(line: 183, column: 5, scope: !35)
!63 = !DILocation(line: 186, column: 24, scope: !35)
!64 = !DILocation(line: 186, column: 5, scope: !35)
!65 = !DILocation(line: 187, column: 24, scope: !35)
!66 = !DILocation(line: 187, column: 5, scope: !35)
!67 = !DILocation(line: 190, column: 17, scope: !35)
!68 = !DILocation(line: 190, column: 21, scope: !35)
!69 = !DILocation(line: 190, column: 5, scope: !35)
!70 = !DILocation(line: 191, column: 17, scope: !35)
!71 = !DILocation(line: 191, column: 21, scope: !35)
!72 = !DILocation(line: 191, column: 5, scope: !35)
!73 = !DILocation(line: 197, column: 17, scope: !35)
!74 = !DILocation(line: 197, column: 31, scope: !35)
!75 = !DILocation(line: 197, column: 23, scope: !35)
!76 = !DILocation(line: 197, column: 21, scope: !35)
!77 = !DILocation(line: 197, column: 5, scope: !35)
!78 = !DILocation(line: 198, column: 17, scope: !35)
!79 = !DILocation(line: 198, column: 21, scope: !35)
!80 = !DILocation(line: 198, column: 5, scope: !35)
!81 = !DILocation(line: 205, column: 43, scope: !35)
!82 = !DILocation(line: 205, column: 53, scope: !35)
!83 = !DILocation(line: 205, column: 11, scope: !35)
!84 = !DILocation(line: 207, column: 10, scope: !35)
!85 = !DILocation(line: 207, column: 5, scope: !35)
!86 = !DILocation(line: 208, column: 5, scope: !35)
!87 = !DILocation(line: 209, column: 1, scope: !35)
!88 = distinct !DISubprogram(name: "dr_w_dev_read", scope: !18, file: !18, line: 77, type: !89, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !40)
!89 = !DISubroutineType(types: !90)
!90 = !{!91, !16, !5, !7, !94}
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "ssize_t", file: !92, line: 78, baseType: !93)
!92 = !DIFile(filename: "/usr/include/stdio.h", directory: "", checksumkind: CSK_MD5, checksum: "1e435c46987a169d9f9186f63a512303")
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "__ssize_t", file: !13, line: 194, baseType: !15)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!95 = !DILocalVariable(name: "filep", arg: 1, scope: !88, file: !18, line: 77, type: !16)
!96 = !DILocation(line: 77, column: 43, scope: !88)
!97 = !DILocalVariable(name: "buffer", arg: 2, scope: !88, file: !18, line: 77, type: !5)
!98 = !DILocation(line: 77, column: 63, scope: !88)
!99 = !DILocalVariable(name: "len", arg: 3, scope: !88, file: !18, line: 78, type: !7)
!100 = !DILocation(line: 78, column: 37, scope: !88)
!101 = !DILocalVariable(name: "offset", arg: 4, scope: !88, file: !18, line: 78, type: !94)
!102 = !DILocation(line: 78, column: 50, scope: !88)
!103 = !DILocalVariable(name: "ret", scope: !88, file: !18, line: 80, type: !39)
!104 = !DILocation(line: 80, column: 9, scope: !88)
!105 = !DILocalVariable(name: "bytes_to_read", scope: !88, file: !18, line: 81, type: !39)
!106 = !DILocation(line: 81, column: 9, scope: !88)
!107 = !DILocation(line: 81, column: 25, scope: !88)
!108 = !DILocation(line: 83, column: 9, scope: !109)
!109 = distinct !DILexicalBlock(scope: !88, file: !18, line: 83, column: 9)
!110 = !DILocation(line: 83, column: 23, scope: !109)
!111 = !DILocation(line: 83, column: 9, scope: !88)
!112 = !DILocation(line: 85, column: 9, scope: !113)
!113 = distinct !DILexicalBlock(scope: !109, file: !18, line: 83, column: 29)
!114 = !DILocation(line: 162, column: 11, scope: !115)
!115 = !DILexicalBlockFile(scope: !88, file: !36, discriminator: 0)
!116 = !DILocation(line: 162, column: 9, scope: !115)
!117 = !DILocation(line: 163, column: 9, scope: !118)
!118 = distinct !DILexicalBlock(scope: !115, file: !36, line: 163, column: 9)
!119 = !DILocation(line: 163, column: 13, scope: !118)
!120 = !DILocation(line: 163, column: 9, scope: !115)
!121 = !DILocation(line: 164, column: 20, scope: !122)
!122 = distinct !DILexicalBlock(scope: !118, file: !36, line: 163, column: 19)
!123 = !DILocation(line: 164, column: 10, scope: !122)
!124 = !DILocation(line: 164, column: 17, scope: !122)
!125 = !DILocation(line: 165, column: 16, scope: !122)
!126 = !DILocation(line: 165, column: 9, scope: !122)
!127 = !DILocation(line: 167, column: 9, scope: !128)
!128 = distinct !DILexicalBlock(scope: !118, file: !36, line: 166, column: 12)
!129 = !DILocation(line: 169, column: 1, scope: !115)
!130 = distinct !DISubprogram(name: "memcpy", scope: !131, file: !131, line: 12, type: !132, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !23, retainedNodes: !40)
!131 = !DIFile(filename: "runtime/Freestanding/memcpy.c", directory: "/home/shafi/tools/klee", checksumkind: CSK_MD5, checksum: "c636d77d986b2156da8c1ff12af1c5cd")
!132 = !DISubroutineType(types: !133)
!133 = !{!134, !134, !135, !7}
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!136 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!137 = !DILocalVariable(name: "destaddr", arg: 1, scope: !130, file: !131, line: 12, type: !134)
!138 = !DILocation(line: 12, column: 20, scope: !130)
!139 = !DILocalVariable(name: "srcaddr", arg: 2, scope: !130, file: !131, line: 12, type: !135)
!140 = !DILocation(line: 12, column: 42, scope: !130)
!141 = !DILocalVariable(name: "len", arg: 3, scope: !130, file: !131, line: 12, type: !7)
!142 = !DILocation(line: 12, column: 58, scope: !130)
!143 = !DILocalVariable(name: "dest", scope: !130, file: !131, line: 13, type: !5)
!144 = !DILocation(line: 13, column: 9, scope: !130)
!145 = !DILocation(line: 13, column: 16, scope: !130)
!146 = !DILocalVariable(name: "src", scope: !130, file: !131, line: 14, type: !147)
!147 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !148, size: 64)
!148 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!149 = !DILocation(line: 14, column: 15, scope: !130)
!150 = !DILocation(line: 14, column: 21, scope: !130)
!151 = !DILocation(line: 16, column: 3, scope: !130)
!152 = !DILocation(line: 16, column: 13, scope: !130)
!153 = !DILocation(line: 16, column: 16, scope: !130)
!154 = !DILocation(line: 17, column: 19, scope: !130)
!155 = !DILocation(line: 17, column: 15, scope: !130)
!156 = !DILocation(line: 17, column: 10, scope: !130)
!157 = !DILocation(line: 17, column: 13, scope: !130)
!158 = distinct !{!158, !151, !154, !159}
!159 = !{!"llvm.loop.mustprogress"}
!160 = !DILocation(line: 18, column: 10, scope: !130)
!161 = !DILocation(line: 18, column: 3, scope: !130)
!162 = distinct !DISubprogram(name: "memset", scope: !163, file: !163, line: 12, type: !164, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !25, retainedNodes: !40)
!163 = !DIFile(filename: "runtime/Freestanding/memset.c", directory: "/home/shafi/tools/klee", checksumkind: CSK_MD5, checksum: "f66ef9ef9131ab198e93a41b1a9ae1fc")
!164 = !DISubroutineType(types: !165)
!165 = !{!134, !134, !39, !7}
!166 = !DILocalVariable(name: "dst", arg: 1, scope: !162, file: !163, line: 12, type: !134)
!167 = !DILocation(line: 12, column: 20, scope: !162)
!168 = !DILocalVariable(name: "s", arg: 2, scope: !162, file: !163, line: 12, type: !39)
!169 = !DILocation(line: 12, column: 29, scope: !162)
!170 = !DILocalVariable(name: "count", arg: 3, scope: !162, file: !163, line: 12, type: !7)
!171 = !DILocation(line: 12, column: 39, scope: !162)
!172 = !DILocalVariable(name: "a", scope: !162, file: !163, line: 13, type: !5)
!173 = !DILocation(line: 13, column: 9, scope: !162)
!174 = !DILocation(line: 13, column: 13, scope: !162)
!175 = !DILocation(line: 14, column: 3, scope: !162)
!176 = !DILocation(line: 14, column: 15, scope: !162)
!177 = !DILocation(line: 14, column: 18, scope: !162)
!178 = !DILocation(line: 15, column: 12, scope: !162)
!179 = !DILocation(line: 15, column: 7, scope: !162)
!180 = !DILocation(line: 15, column: 10, scope: !162)
!181 = distinct !{!181, !175, !178, !159}
!182 = !DILocation(line: 16, column: 10, scope: !162)
!183 = !DILocation(line: 16, column: 3, scope: !162)
