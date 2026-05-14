; ModuleID = 'out/eval2_linux/path_a/rev_chardev_line193/harness.bc'
source_filename = "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_rev_chardev_line193.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@message = internal global [1024 x i8] zeroinitializer, align 16, !dbg !0
@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@message_size = internal global i16 0, align 2, !dbg !13
@.str.1 = private unnamed_addr constant [4 x i8] c"len\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"offset\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !30 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca [256 x i8], align 16
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !36, metadata !DIExpression()), !dbg !37
  call void @llvm.dbg.declare(metadata i64* %3, metadata !38, metadata !DIExpression()), !dbg !39
  call void @llvm.dbg.declare(metadata [256 x i8]* %4, metadata !40, metadata !DIExpression()), !dbg !44
  %5 = call i8* @strcpy(i8* noundef getelementptr inbounds ([1024 x i8], [1024 x i8]* @message, i64 0, i64 0), i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i64 0, i64 0)) #6, !dbg !45
  store i16 5, i16* @message_size, align 2, !dbg !46
  %6 = bitcast i64* %2 to i8*, !dbg !47
  call void @klee_make_symbolic(i8* noundef %6, i64 noundef 8, i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0)), !dbg !48
  %7 = bitcast i64* %3 to i8*, !dbg !49
  call void @klee_make_symbolic(i8* noundef %7, i64 noundef 8, i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0)), !dbg !50
  %8 = load i64, i64* %2, align 8, !dbg !51
  %9 = icmp ugt i64 %8, 0, !dbg !52
  %10 = zext i1 %9 to i32, !dbg !52
  %11 = sext i32 %10 to i64, !dbg !51
  call void @klee_assume(i64 noundef %11), !dbg !53
  %12 = load i64, i64* %2, align 8, !dbg !54
  %13 = icmp ule i64 %12, 64, !dbg !55
  %14 = zext i1 %13 to i32, !dbg !55
  %15 = sext i32 %14 to i64, !dbg !54
  call void @klee_assume(i64 noundef %15), !dbg !56
  %16 = load i64, i64* %3, align 8, !dbg !57
  %17 = icmp sgt i64 %16, 1024, !dbg !58
  %18 = zext i1 %17 to i32, !dbg !58
  %19 = sext i32 %18 to i64, !dbg !57
  call void @klee_assume(i64 noundef %19), !dbg !59
  %20 = load i64, i64* %3, align 8, !dbg !60
  %21 = icmp slt i64 %20, 1048576, !dbg !61
  %22 = zext i1 %21 to i32, !dbg !61
  %23 = sext i32 %22 to i64, !dbg !60
  call void @klee_assume(i64 noundef %23), !dbg !62
  %24 = getelementptr inbounds [256 x i8], [256 x i8]* %4, i64 0, i64 0, !dbg !63
  %25 = load i64, i64* %2, align 8, !dbg !64
  %26 = call i64 @dev_read(i8* noundef null, i8* noundef %24, i64 noundef %25, i64* noundef %3), !dbg !65
  ret i32 0, !dbg !66
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare i8* @strcpy(i8* noundef, i8* noundef) #2

declare void @klee_make_symbolic(i8* noundef, i64 noundef, i8* noundef) #3

declare void @klee_assume(i64 noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal i64 @dev_read(i8* noundef %0, i8* noundef %1, i64 noundef %2, i64* noundef %3) #0 !dbg !67 {
  %5 = alloca i64, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64*, align 8
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i8* %0, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !72, metadata !DIExpression()), !dbg !73
  store i8* %1, i8** %7, align 8
  call void @llvm.dbg.declare(metadata i8** %7, metadata !74, metadata !DIExpression()), !dbg !75
  store i64 %2, i64* %8, align 8
  call void @llvm.dbg.declare(metadata i64* %8, metadata !76, metadata !DIExpression()), !dbg !77
  store i64* %3, i64** %9, align 8
  call void @llvm.dbg.declare(metadata i64** %9, metadata !78, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.declare(metadata i32* %10, metadata !80, metadata !DIExpression()), !dbg !81
  call void @llvm.dbg.declare(metadata i32* %11, metadata !82, metadata !DIExpression()), !dbg !83
  br label %12, !dbg !84

12:                                               ; preds = %4
  br label %13, !dbg !85

13:                                               ; preds = %12
  %14 = load i64, i64* %8, align 8, !dbg !87
  %15 = load i16, i16* @message_size, align 2, !dbg !87
  %16 = sext i16 %15 to i64, !dbg !87
  %17 = load i64*, i64** %9, align 8, !dbg !87
  %18 = load i64, i64* %17, align 8, !dbg !87
  %19 = sub nsw i64 %16, %18, !dbg !87
  %20 = icmp ult i64 %14, %19, !dbg !87
  br i1 %20, label %21, label %23, !dbg !87

21:                                               ; preds = %13
  %22 = load i64, i64* %8, align 8, !dbg !87
  br label %29, !dbg !87

23:                                               ; preds = %13
  %24 = load i16, i16* @message_size, align 2, !dbg !87
  %25 = sext i16 %24 to i64, !dbg !87
  %26 = load i64*, i64** %9, align 8, !dbg !87
  %27 = load i64, i64* %26, align 8, !dbg !87
  %28 = sub nsw i64 %25, %27, !dbg !87
  br label %29, !dbg !87

29:                                               ; preds = %23, %21
  %30 = phi i64 [ %22, %21 ], [ %28, %23 ], !dbg !87
  %31 = trunc i64 %30 to i32, !dbg !87
  store i32 %31, i32* %11, align 4, !dbg !88
  %32 = load i32, i32* %11, align 4, !dbg !89
  %33 = icmp sle i32 %32, 0, !dbg !91
  br i1 %33, label %34, label %39, !dbg !92

34:                                               ; preds = %29
  br label %35, !dbg !93

35:                                               ; preds = %34
  br label %36, !dbg !95

36:                                               ; preds = %35
  br label %37, !dbg !97

37:                                               ; preds = %36
  br label %38, !dbg !98

38:                                               ; preds = %37
  store i64 0, i64* %5, align 8, !dbg !100
  br label %62, !dbg !100

39:                                               ; preds = %29
  %40 = load i8*, i8** %7, align 8, !dbg !101
  %41 = load i64*, i64** %9, align 8, !dbg !101
  %42 = load i64, i64* %41, align 8, !dbg !101
  %43 = getelementptr inbounds i8, i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @message, i64 0, i64 0), i64 %42, !dbg !101
  %44 = load i32, i32* %11, align 4, !dbg !101
  %45 = sext i32 %44 to i64, !dbg !101
  %46 = call i8* @memcpy(i8* %40, i8* %43, i64 %45), !dbg !101
  store i32 0, i32* %10, align 4, !dbg !103
  %47 = load i32, i32* %10, align 4, !dbg !104
  %48 = icmp eq i32 %47, 0, !dbg !106
  br i1 %48, label %49, label %59, !dbg !107

49:                                               ; preds = %39
  %50 = load i32, i32* %11, align 4, !dbg !108
  %51 = sext i32 %50 to i64, !dbg !108
  %52 = load i64*, i64** %9, align 8, !dbg !110
  %53 = load i64, i64* %52, align 8, !dbg !111
  %54 = add nsw i64 %53, %51, !dbg !111
  store i64 %54, i64* %52, align 8, !dbg !111
  br label %55, !dbg !112

55:                                               ; preds = %49
  br label %56, !dbg !113

56:                                               ; preds = %55
  %57 = load i32, i32* %11, align 4, !dbg !115
  %58 = sext i32 %57 to i64, !dbg !115
  store i64 %58, i64* %5, align 8, !dbg !116
  br label %62, !dbg !116

59:                                               ; preds = %39
  br label %60, !dbg !117

60:                                               ; preds = %59
  br label %61, !dbg !119

61:                                               ; preds = %60
  store i64 -14, i64* %5, align 8, !dbg !121
  br label %62, !dbg !121

62:                                               ; preds = %61, %56, %38
  %63 = load i64, i64* %5, align 8, !dbg !122
  ret i64 %63, !dbg !122
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @memcpy(i8* noundef %0, i8* noundef %1, i64 noundef %2) #5 !dbg !123 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !129, metadata !DIExpression()), !dbg !130
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !131, metadata !DIExpression()), !dbg !132
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !133, metadata !DIExpression()), !dbg !134
  call void @llvm.dbg.declare(metadata i8** %7, metadata !135, metadata !DIExpression()), !dbg !136
  %9 = load i8*, i8** %4, align 8, !dbg !137
  store i8* %9, i8** %7, align 8, !dbg !136
  call void @llvm.dbg.declare(metadata i8** %8, metadata !138, metadata !DIExpression()), !dbg !141
  %10 = load i8*, i8** %5, align 8, !dbg !142
  store i8* %10, i8** %8, align 8, !dbg !141
  br label %11, !dbg !143

11:                                               ; preds = %15, %3
  %12 = load i64, i64* %6, align 8, !dbg !144
  %13 = add i64 %12, -1, !dbg !144
  store i64 %13, i64* %6, align 8, !dbg !144
  %14 = icmp ugt i64 %12, 0, !dbg !145
  br i1 %14, label %15, label %21, !dbg !143

15:                                               ; preds = %11
  %16 = load i8*, i8** %8, align 8, !dbg !146
  %17 = getelementptr inbounds i8, i8* %16, i32 1, !dbg !146
  store i8* %17, i8** %8, align 8, !dbg !146
  %18 = load i8, i8* %16, align 1, !dbg !147
  %19 = load i8*, i8** %7, align 8, !dbg !148
  %20 = getelementptr inbounds i8, i8* %19, i32 1, !dbg !148
  store i8* %20, i8** %7, align 8, !dbg !148
  store i8 %18, i8* %19, align 1, !dbg !149
  br label %11, !dbg !143, !llvm.loop !150

21:                                               ; preds = %11
  %22 = load i8*, i8** %4, align 8, !dbg !152
  ret i8* %22, !dbg !153
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { argmemonly nofree nounwind willreturn }
attributes #5 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2, !20}
!llvm.module.flags = !{!22, !23, !24, !25, !26, !27, !28}
!llvm.ident = !{!29, !29}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "message", scope: !2, file: !6, line: 44, type: !16, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !12, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_rev_chardev_line193.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "2f819924af07cc805af5baea83fbd084")
!4 = !{!5, !8, !9}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "loff_t", file: !6, line: 37, baseType: !7)
!6 = !DIFile(filename: "out/eval2_linux/harnesses/harness_rev_chardev_line193.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "2f819924af07cc805af5baea83fbd084")
!7 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !10, line: 46, baseType: !11)
!10 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!11 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!12 = !{!13, !0}
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "message_size", scope: !2, file: !6, line: 45, type: !15, isLocal: true, isDefinition: true)
!15 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 8192, elements: !18)
!17 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!18 = !{!19}
!19 = !DISubrange(count: 1024)
!20 = distinct !DICompileUnit(language: DW_LANG_C99, file: !21, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!21 = !DIFile(filename: "/home/shafi/tools/klee/runtime/Freestanding/memcpy.c", directory: "/home/shafi/tools/klee/build/runtime/Freestanding", checksumkind: CSK_MD5, checksum: "c636d77d986b2156da8c1ff12af1c5cd")
!22 = !{i32 7, !"Dwarf Version", i32 5}
!23 = !{i32 2, !"Debug Info Version", i32 3}
!24 = !{i32 1, !"wchar_size", i32 4}
!25 = !{i32 7, !"PIC Level", i32 2}
!26 = !{i32 7, !"PIE Level", i32 2}
!27 = !{i32 7, !"uwtable", i32 1}
!28 = !{i32 7, !"frame-pointer", i32 2}
!29 = !{!"Ubuntu clang version 14.0.6"}
!30 = distinct !DISubprogram(name: "main", scope: !31, file: !31, line: 204, type: !32, scopeLine: 205, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !35)
!31 = !DIFile(filename: "rev_chardev.c", directory: "/home/shafi/harden/eval3_demo/stase3")
!32 = !DISubroutineType(types: !33)
!33 = !{!34}
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !{}
!36 = !DILocalVariable(name: "len", scope: !30, file: !31, line: 206, type: !9)
!37 = !DILocation(line: 206, column: 12, scope: !30)
!38 = !DILocalVariable(name: "offset", scope: !30, file: !31, line: 207, type: !5)
!39 = !DILocation(line: 207, column: 12, scope: !30)
!40 = !DILocalVariable(name: "user_buf", scope: !30, file: !31, line: 208, type: !41)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 2048, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 256)
!44 = !DILocation(line: 208, column: 10, scope: !30)
!45 = !DILocation(line: 211, column: 5, scope: !30)
!46 = !DILocation(line: 212, column: 18, scope: !30)
!47 = !DILocation(line: 215, column: 24, scope: !30)
!48 = !DILocation(line: 215, column: 5, scope: !30)
!49 = !DILocation(line: 216, column: 24, scope: !30)
!50 = !DILocation(line: 216, column: 5, scope: !30)
!51 = !DILocation(line: 220, column: 17, scope: !30)
!52 = !DILocation(line: 220, column: 21, scope: !30)
!53 = !DILocation(line: 220, column: 5, scope: !30)
!54 = !DILocation(line: 221, column: 17, scope: !30)
!55 = !DILocation(line: 221, column: 21, scope: !30)
!56 = !DILocation(line: 221, column: 5, scope: !30)
!57 = !DILocation(line: 222, column: 17, scope: !30)
!58 = !DILocation(line: 222, column: 24, scope: !30)
!59 = !DILocation(line: 222, column: 5, scope: !30)
!60 = !DILocation(line: 223, column: 17, scope: !30)
!61 = !DILocation(line: 223, column: 24, scope: !30)
!62 = !DILocation(line: 223, column: 5, scope: !30)
!63 = !DILocation(line: 229, column: 20, scope: !30)
!64 = !DILocation(line: 229, column: 30, scope: !30)
!65 = !DILocation(line: 229, column: 5, scope: !30)
!66 = !DILocation(line: 230, column: 5, scope: !30)
!67 = distinct !DISubprogram(name: "dev_read", scope: !6, file: !6, line: 53, type: !68, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !35)
!68 = !DISubroutineType(types: !69)
!69 = !{!7, !8, !70, !9, !71}
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!72 = !DILocalVariable(name: "filep", arg: 1, scope: !67, file: !6, line: 53, type: !8)
!73 = !DILocation(line: 53, column: 28, scope: !67)
!74 = !DILocalVariable(name: "buffer", arg: 2, scope: !67, file: !6, line: 53, type: !70)
!75 = !DILocation(line: 53, column: 41, scope: !67)
!76 = !DILocalVariable(name: "len", arg: 3, scope: !67, file: !6, line: 53, type: !9)
!77 = !DILocation(line: 53, column: 56, scope: !67)
!78 = !DILocalVariable(name: "offset", arg: 4, scope: !67, file: !6, line: 53, type: !71)
!79 = !DILocation(line: 53, column: 69, scope: !67)
!80 = !DILocalVariable(name: "ret", scope: !67, file: !6, line: 55, type: !34)
!81 = !DILocation(line: 55, column: 9, scope: !67)
!82 = !DILocalVariable(name: "bytes_to_read", scope: !67, file: !6, line: 56, type: !34)
!83 = !DILocation(line: 56, column: 9, scope: !67)
!84 = !DILocation(line: 58, column: 5, scope: !67)
!85 = !DILocation(line: 58, column: 5, scope: !86)
!86 = distinct !DILexicalBlock(scope: !67, file: !6, line: 58, column: 5)
!87 = !DILocation(line: 60, column: 21, scope: !67)
!88 = !DILocation(line: 60, column: 19, scope: !67)
!89 = !DILocation(line: 61, column: 9, scope: !90)
!90 = distinct !DILexicalBlock(scope: !67, file: !6, line: 61, column: 9)
!91 = !DILocation(line: 61, column: 23, scope: !90)
!92 = !DILocation(line: 61, column: 9, scope: !67)
!93 = !DILocation(line: 62, column: 9, scope: !94)
!94 = distinct !DILexicalBlock(scope: !90, file: !6, line: 61, column: 29)
!95 = !DILocation(line: 62, column: 9, scope: !96)
!96 = distinct !DILexicalBlock(scope: !94, file: !6, line: 62, column: 9)
!97 = !DILocation(line: 63, column: 9, scope: !94)
!98 = !DILocation(line: 63, column: 9, scope: !99)
!99 = distinct !DILexicalBlock(scope: !94, file: !6, line: 63, column: 9)
!100 = !DILocation(line: 64, column: 9, scope: !94)
!101 = !DILocation(line: 193, column: 11, scope: !102)
!102 = !DILexicalBlockFile(scope: !67, file: !31, discriminator: 0)
!103 = !DILocation(line: 193, column: 9, scope: !102)
!104 = !DILocation(line: 194, column: 9, scope: !105)
!105 = distinct !DILexicalBlock(scope: !102, file: !31, line: 194, column: 9)
!106 = !DILocation(line: 194, column: 13, scope: !105)
!107 = !DILocation(line: 194, column: 9, scope: !102)
!108 = !DILocation(line: 195, column: 20, scope: !109)
!109 = distinct !DILexicalBlock(scope: !105, file: !31, line: 194, column: 19)
!110 = !DILocation(line: 195, column: 10, scope: !109)
!111 = !DILocation(line: 195, column: 17, scope: !109)
!112 = !DILocation(line: 196, column: 9, scope: !109)
!113 = !DILocation(line: 196, column: 9, scope: !114)
!114 = distinct !DILexicalBlock(scope: !109, file: !31, line: 196, column: 9)
!115 = !DILocation(line: 197, column: 16, scope: !109)
!116 = !DILocation(line: 197, column: 9, scope: !109)
!117 = !DILocation(line: 199, column: 9, scope: !118)
!118 = distinct !DILexicalBlock(scope: !105, file: !31, line: 198, column: 12)
!119 = !DILocation(line: 199, column: 9, scope: !120)
!120 = distinct !DILexicalBlock(scope: !118, file: !31, line: 199, column: 9)
!121 = !DILocation(line: 200, column: 9, scope: !118)
!122 = !DILocation(line: 202, column: 1, scope: !102)
!123 = distinct !DISubprogram(name: "memcpy", scope: !124, file: !124, line: 12, type: !125, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !20, retainedNodes: !35)
!124 = !DIFile(filename: "runtime/Freestanding/memcpy.c", directory: "/home/shafi/tools/klee", checksumkind: CSK_MD5, checksum: "c636d77d986b2156da8c1ff12af1c5cd")
!125 = !DISubroutineType(types: !126)
!126 = !{!8, !8, !127, !9}
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!129 = !DILocalVariable(name: "destaddr", arg: 1, scope: !123, file: !124, line: 12, type: !8)
!130 = !DILocation(line: 12, column: 20, scope: !123)
!131 = !DILocalVariable(name: "srcaddr", arg: 2, scope: !123, file: !124, line: 12, type: !127)
!132 = !DILocation(line: 12, column: 42, scope: !123)
!133 = !DILocalVariable(name: "len", arg: 3, scope: !123, file: !124, line: 12, type: !9)
!134 = !DILocation(line: 12, column: 58, scope: !123)
!135 = !DILocalVariable(name: "dest", scope: !123, file: !124, line: 13, type: !70)
!136 = !DILocation(line: 13, column: 9, scope: !123)
!137 = !DILocation(line: 13, column: 16, scope: !123)
!138 = !DILocalVariable(name: "src", scope: !123, file: !124, line: 14, type: !139)
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !140, size: 64)
!140 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !17)
!141 = !DILocation(line: 14, column: 15, scope: !123)
!142 = !DILocation(line: 14, column: 21, scope: !123)
!143 = !DILocation(line: 16, column: 3, scope: !123)
!144 = !DILocation(line: 16, column: 13, scope: !123)
!145 = !DILocation(line: 16, column: 16, scope: !123)
!146 = !DILocation(line: 17, column: 19, scope: !123)
!147 = !DILocation(line: 17, column: 15, scope: !123)
!148 = !DILocation(line: 17, column: 10, scope: !123)
!149 = !DILocation(line: 17, column: 13, scope: !123)
!150 = distinct !{!150, !143, !146, !151}
!151 = !{!"llvm.loop.mustprogress"}
!152 = !DILocation(line: 18, column: 10, scope: !123)
!153 = !DILocation(line: 18, column: 3, scope: !123)
