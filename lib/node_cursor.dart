part of angular;


class NodeCursor {
  var stack = [];
  var elements;
  var index;

  NodeCursor(this.elements) {
    index = 0;
  }

  isValid() {
    return index < elements.length;
  }

  cursorSize() {
    return 1;
  }

  macroNext() {
    for(var i = 0, ii = cursorSize(); i < ii; i++, index++){}

    return this.isValid();
  }

  microNext() {
    var length = elements.length;

    if (index < length) {
      index++;
    }

    return index < length;
  }

  nodeList() {
    if (!isValid()) return [];  // or should we return null?

    var node = elements[index];
    var nodes = [];

    for(var i = 0, ii = cursorSize(); i < ii; i++) {
      nodes.add(elements[index + i]);
    }

    return nodes;
  }

  descend() {
    var childNodes = elements[index].nodes;
    var hasChildren = !!(childNodes != null && childNodes.length > 0);

    if (hasChildren) {
      stack.add(index);
      stack.add(elements);
      elements = new List.from(childNodes);
      index = 0;
    }

    return hasChildren;
  }

  ascend() {
    elements = stack.removeLast();
    index = stack.removeLast();
  }

  insertAnchorBefore(name) {
    var current = elements[index];
    var parent = current.parentNode;

    var anchor = new dom.Comment('ANCHOR: $name');

    elements.insert(index++, anchor);

    if (parent != null) {
      parent.insertBefore(anchor, current);
    }
  }

  replaceWithAnchor(name) {
    insertAnchorBefore(name);
    var childCursor = remove();
    this.index--;
    return childCursor;
  }

  remove() {
    var nodes = nodeList();

    for (var i = 0, ii = nodes.length; i < ii; i++) {
      // NOTE(deboer): If elements is a list of child nodes on a node, then
      // calling Node.remove() may also remove it from the list.  Thus, we
      // call elements.removeAt first so only one node is removed.
      elements.removeAt(index);
      nodes[i].remove();
    }

    return new NodeCursor(nodes);
  }

  isInstance() {
    return false;
  }
}
