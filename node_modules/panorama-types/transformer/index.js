"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const tslib_1 = require("tslib");
const ts = tslib_1.__importStar(require("typescript"));
// eslint-disable-next-line @typescript-eslint/no-require-imports
const mappings = require('./mappings.json');
function getMapping(name) {
    if (Object.prototype.hasOwnProperty.call(mappings, name)) {
        return mappings[name];
    }
}
function createNodeFromReplacement(replacement) {
    const [global, member] = replacement.split('.');
    return ts.createPropertyAccess(ts.createIdentifier(global), member);
}
const replaceNode = (node) => {
    if (ts.isIdentifier(node)) {
        const replacement = getMapping(node.text);
        if (typeof replacement !== 'string')
            return;
        return createNodeFromReplacement(replacement);
    }
    // Would be handled as a part of main process of const enum transform
    if (!ts.isPropertyAccessExpression(node) && !ts.isElementAccessExpression(node))
        return;
    const { expression } = node;
    if (!ts.isIdentifier(expression))
        return;
    const enumMembers = getMapping(expression.text);
    if (typeof enumMembers !== 'object')
        return;
    let nameText;
    if (ts.isPropertyAccessExpression(node)) {
        nameText = node.name.text;
    }
    else if (ts.isElementAccessExpression(node)) {
        if (!ts.isStringLiteral(node.argumentExpression)) {
            return;
        }
        nameText = node.argumentExpression.text;
    }
    else {
        return;
    }
    if (Object.prototype.hasOwnProperty.call(enumMembers, nameText)) {
        return createNodeFromReplacement(enumMembers[nameText]);
    }
};
const createDotaTransformer = () => (context) => {
    const visit = (node) => replaceNode(node) || ts.visitEachChild(node, visit, context);
    return (file) => ts.visitNode(file, visit);
};
exports.default = createDotaTransformer;
