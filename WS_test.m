% 生成一个WS小世界网络并进行分析


close all;
clear;
clc;

% 生成网络 ===========================

% % 【重新生成】
% N = 1000;
% K = 10;
% P = 0.6;
% G = WS(N,K,P);
% S = Stat(G);

% % 【加载已生成】
load("WS_test.mat");

% 可视化 ================

VisualizeStat(G,S);

figure("Name","WS");
plot(G);
